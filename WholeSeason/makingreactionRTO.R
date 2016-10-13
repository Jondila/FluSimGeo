RTODATA <- read.csv(file = 'RTODATA.csv', as.is=T)
RTODATA <- RTODATA[!grepl("Area Outside RTO", RTODATA$Home_RTO),]
RTODATA <- RTODATA[!grepl("Area Outside RTO", RTODATA$RTO),]
RTODATA <- RTODATA[!grepl("NULL", RTODATA$RTO),]
RTODATA

RTO_Names <- unique(RTODATA$RTO)

N <- length(RTODATA$Home_RTO)
fileName <- "reactionsRTO.xml"

for(k in 1:N)	{
		Home_RTO <- RTODATA$Home_RTO[k]
		RTO <- RTODATA$RTO[k]
		Rate <- RTODATA$Rate1[k]

		RTO_Index <-which(RTO_Names==RTO)-1
		Home_RTO_Index <- which(RTO_Names==Home_RTO)-1

	if(Home_RTO_Index != RTO_Index){
		str <- paste("<reaction spec='Reaction' rate='",Rate,
		"'>\nI[",Home_RTO_Index,"]+ S[",RTO_Index,"] ->I[",Home_RTO_Index,"] + I[",RTO_Index,"]\n",
		"</reaction>\n",sep="")
	}
	else {
		str <- paste("<reaction spec='Reaction' rate='",Rate,
			"'>\nI[",Home_RTO_Index,"] + S[",Home_RTO_Index,"] -> 2I[",Home_RTO_Index,"]\n",
			"</reaction>\n",sep="")
	}
	cat(str, file=fileName, append=T)
}
