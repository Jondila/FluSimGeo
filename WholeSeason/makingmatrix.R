## Load data

dfPopSizes <- read.csv(file = 'RTOPOP.csv', as.is=T)
dfTP <- read.csv(file = 'RTODATA.csv', as.is=T)

## Remove Area Outside and NULL

dfPopSizes <-dfPopSizes[!grepl("Area Outside RTO", dfPopSizes$rtonames),]
dfTP <- df[!grepl("Area Outside RTO", df$Home_RTO),]
dfTP <- df[!grepl("Area Outside RTO", df$RTO),]
dfTP <- df[!grepl("NULL", df$RTO),]

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

R0 <- 1.2
infectiousPeriod <- 1 # week

recoveryRate <- 1/infectiousPeriod

beta <- rep(0, N)
for (i in 1:N) {
    beta[i] <- R0*recoveryRate/(epsilon[i,i]*RTO_PopSizes[i])
}

infectionRate <- matrix(0, nrow=N, ncol=N)
for (i in 1:N) {
    for (j in 1:N) {
        infectionRate[i,j] <- beta[j]*epsilon[i,j]
    }
}
