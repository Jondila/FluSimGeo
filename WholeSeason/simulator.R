## Load data

dfPopSizes <- read.csv(file = 'RTOPOP.csv', as.is=T)
dfTP <- read.csv(file = 'RTODATA.csv', as.is=T)

## Remove Area Outside and NULL

dfPopSizes <-dfPopSizes[!grepl("Area Outside RTO", dfPopSizes$rtonames),]
dfTP <- dfTP[!grepl("Area Outside RTO", dfTP$Home_RTO),]
dfTP <- dfTP[!grepl("Area Outside RTO", dfTP$RTO),]
dfTP <- dfTP[!grepl("NULL", dfTP$RTO),]

## Assemble list of names and sort

RTO_Names <- sort(unique(dfTP$RTO))
N <- length(RTO_Names)

dfPopSizes <- dfPopSizes[order(dfPopSizes$rtonames),]
RTO_PopSizes <- dfPopSizes$popsize

## Compute epsilon matrix

epsilon <- matrix(0, nrow = N, ncol = N)

for (i in 1:N) {
  iName <- RTO_Names[i]
  for (j in 1:N) {
    if (i==j)
      next

    jName <- RTO_Names[j]

    recIdx <- which(dfTP$Home_RTO==iName & dfTP$RTO ==jName)
    if (length(recIdx)>0) {
      epsilon[i,j] <- dfTP$Rate[recIdx]
    }
  }
}

diag(epsilon) <- 1 - rowSums(epsilon)

## Compute reaction rates

getReactionRates <- function(R0, infectiousPeriod) {
    recoveryRate <- rep(1/infectiousPeriod, N)

    beta <- rep(0, N)
    for (i in 1:N) {
        beta[i] <- R0*recoveryRate[i]/(epsilon[i,i]*RTO_PopSizes[i])
    }

    infectionRate <- matrix(0, nrow=N, ncol=N)
    for (i in 1:N) {
        for (j in 1:N) {
            infectionRate[i,j] <- beta[j]*epsilon[i,j]
        }
    }

    result <- list()
    result$recoveryRate <- recoveryRate
    result$infectionRate <- infectionRate

    return(result)
}

## Creates a MASTER XML file using rates computed previously 

createXML <- function(fileName="simulation.xml", R0=1.2, infectiousPeriod=0.5, initialLoc=1, initialInfectious=10) {

    ## Obtain rates
    rates <- getReactionRates(R0, infectiousPeriod)

    ## Read in template

    templateFileName <- "MASTER_template.xml"

    templateCon <- file(templateFileName, open="r")
    xmlLines <- readLines(templateCon)
    close(templateCon)

    ## Process template

    cat("", file=fileName, append=F)
    catLine <- function(...) {
        cat(paste(... , sep=""), fill=T, file=fileName, append=T)
    }


    for (line in xmlLines) {
        if (trimws(line) == "%REACTIONS%") {

            for (i in 1:N) {
                for (j in 1:N) {
                    catLine("<reaction spec='Reaction' rate='", rates$infectionRate[i,j], "'>")
                    catLine("    I[",i-1,"] + S[",j-1,"] -> I[",i-1,"] + I[",j-1,"]")
                    catLine("</reaction>")
                }

                catLine("<reaction spec='Reaction' rate='", rates$recoveryRate[i], "'>")
                catLine("    I[",i-1,"] -> 0")
                catLine("</reaction>")
            }

        } else if (trimws(line) == "%INITIALSTATE%") {

            for (i in 1:N) {
                if (i==initialLoc) {
                    numSusceptible <- RTO_PopSizes[i] - initialInfectious;
                } else {
                    numSusceptible <- RTO_PopSizes[i]
                }
                
                catLine("<populationSize spec='PopulationSize' size='", numSusceptible, "'>")
                catLine("    <population spec='Population' type='@S' location='", i-1, "'/>")
                catLine("</populationSize>")
            }

            catLine("<populationSize spec='PopulationSize' size='", initialInfectious, "'>")
            catLine("    <population spec='Population' type='@I' location='", initialLoc-1, "'/>")
            catLine("</populationSize>")
            

        } else {
            catLine(line)
        }
    }
}

## Perform simulation using MASTER and returns the result

library(rjson)

simulate <- function(R0=1.2, infectiousPeriod=0.5, initialLoc=1, initialInfectious=10) {

    createXML("simulation.xml", R0, infectiousPeriod, initialLoc, initialInfectious)
    system("beast simulation.xml")
    data <- fromJSON(file="simulation.json")

    return(data)
}

## Visualize the results using shapefile containing RTO boundaries

library(maptools)
library(fields)
rtoShapes <- readShapePoly("../RTO_boundaries_true/RTO_boundaries_true.shp")
rtoPolyNames <- as.character(rtoShapes$NAME)

getPeakPrevalence <- function(data, relative=FALSE) {
    maxPrev <- 0
    for (i in 1:N) {
        if (relative) {
            maxPrev <- max(c(maxPrev, data$trajectories[[1]]$I[[i]]/RTO_PopSizes[i]))
        } else {
            maxPrev <- max(c(maxPrev, data$trajectories[[1]]$I[[i]]))
        }
    }

    return(maxPrev)
}

getPrevalence <- function(data, t, relative=FALSE) {

    prevalence <- rep(0, N)
    for (i in 1:N) {
        thisName <- RTO_Names[i]
        thisPolyIdx <- which(rtoPolyNames == thisName)

        eventIdx <- max(which(data$trajectories[[1]]$t<=t))
        
        if (relative) {
            thisPrevalence <- data$trajectories[[1]]$I[[i]][eventIdx]/RTO_PopSizes[i]
        } else {
            thisPrevalence <- data$trajectories[[1]]$I[[i]][eventIdx]
        }

        prevalence[thisPolyIdx] <- thisPrevalence
    }

    return(prevalence)
}

plotEpidemic <- function(data, times=20, labels=TRUE) {

    colourPalette <- heat.colors(101)

    nTimes <- length(times)
    par(mfcol=c(1,nTimes))
    par(mar=c(0,0,1,0))

    globalPeak <- getPeakPrevalence(data, relative=TRUE)

    for (tidx in 1:nTimes) {
        t <- times[tidx]

        #prevalence <- getPrevalence(data, t, relative=FALSE)
        #scaledPrevalence <- prevalence/globalPeak
        scaledPrevalence <- getPrevalence(data, t, relative=TRUE)/globalPeak

        colours <- rep(NA, N+1)
        for (i in 2:length(scaledPrevalence)) {
            colours[i] <- colourPalette[1 + floor((1-scaledPrevalence[i])*100)]
            #print(globalPeak)
        }

        borders <- c(NA, rep(1,N))

        plot(rtoShapes, col=colours, border=borders, main=paste(t, "weeks"))

        if (labels) {
            text(coordinates(rtoShapes)[-1,], labels=rtoShapes$NAME[-1], cex=0.8)
        }
    }
}

## Perform simulation and plot in one step

simAndPlot <- function(R0=1.2, infectiousPeriod=0.5, initialLoc=1, initialInfectious=10, plotTimes=20, labels=TRUE) {
    data <- simulate(R0, infectiousPeriod, initialLoc, initialInfectious)
    plotEpidemic(data, plotTimes, labels)
}
