getwd()
setwd("E:/monthly_data")
list.files()
fileList <- list.files(path="E:/monthly_data", pattern=".csv")
sapply(fileList, read.csv)
new.data <- read.csv(file = 'octoberqrious.csv', as.is = TRUE)
##################################################
#data cleaning to remove the area outside RTO
new.data <- new.data[!grepl("Area Outside RTO", new.data$Home_RTO), ] #removed
new.data <- new.data[!grepl("Area Outside RTO", new.data$RTO), ] #removed rows
new.data #clear data without "Area Outside RTO"
#End of Data cleaning

#Formulation of matrix
RTO_Names <- unique(new.data$RTO)
Home_names <- unique(new.data$Home_RTO)
new.data$Rate[new.data$Home_RTO=="Auckland RTO"]
sum(new.data$Rate[new.data$Home_RTO=="Dunedin RTO"])
for (name in RTO_Names) {cat(name)}
N <- length(Home_names)

for (name in Home_names){
  s <- sum(new.data$Rate[new.data$Home_RTO==name])
  cat(paste(s,"\n"))
}

P <- matrix(0, nrow = N, ncol = N)

for (i in 1:N) {
  iName <- RTO_Names[i]
  for (j in 1:N) {
    if (i==j)
      next

    jName <- RTO_Names[j]

    recIdx <- which(new.data$Home_RTO==iName & new.data$RTO ==jName)
    if (length(recIdx)>0) {
      P[i,j] <- new.data$Rate[recIdx]
    }
  }
}

diag(P) <- 1 - rowSums(P)

#end of formulation of matrix

# start program for the reactants (making xml file for the reactions in BEAST 2)
RTO_Names <- unique(new.data$RTO)
N <- length(new.data$Home_RTO)
fileName <- "octobereactions.xml"

for (k in 1:N) {
  Home_RTO <- new.data$Home_RTO[k]
  RTO <- new.data$RTO[k]
  Rate <- new.data$Rate[k]
  RTO_Index <- which(RTO_Names == RTO)
  Home_RTO_Index <- which(RTO_Names == Home_RTO)
if(Home_RTO_Index != RTO_Index){
  str <- paste("<reaction spec='Reaction' rate='",Rate,
  "'>\nS[",RTO_Index,"] + I[",Home_RTO_Index,"] -> I[",RTO_Index,"]+ I[",Home_RTO_Index,"]\n",
  "</reaction>\n",sep="")
}else {
		str <- paste("<reaction spec='Reaction' rate='",Rate,
			"'>\nS[",Home_RTO_Index,"] + I[",Home_RTO_Index,"] -> 2I[",Home_RTO_Index,"]\n",
			"</reaction>\n",sep="")
	}
	cat(str, file=fileName, append=T)
}
# end program for the reactants to make an xml file to be used in BEAST 2
