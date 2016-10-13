Newdata <- read.csv(file = 'RTOPOP.csv')
Newdata <-Newdata[!grepl("Area Outside RTO", Newdata$rtonames),]
A <- Newdata$popsize
df <- read.csv(file = 'RTODATA.csv', as.is=T)
df
df <- df[!grepl("Area Outside RTO", df$Home_RTO),]
df <- df[!grepl("Area Outside RTO", df$RTO),]
df <- df[!grepl("NULL", df$RTO),]
RTO_Names <- unique(df$RTO)
Home_names <- unique(df$Home_RTO)
df$Rate[df$Home_RTO=="Auckland RTO"]
sum(df$Rate[df$Home_RTO=="Dunedin RTO"])
for (name in RTO_Names) {cat(name)}
N <- length(Home_names)

for (name in Home_names){
  s <- sum(df$Rate[df$Home_RTO==name])
  cat(paste(s,"\n"))
}

P <- matrix(0, nrow = N, ncol = N)

for (i in 1:N) {
  iName <- RTO_Names[i]
  for (j in 1:N) {
    if (i==j)
      next

    jName <- RTO_Names[j]

    recIdx <- which(df$Home_RTO==iName & df$RTO ==jName)
    if (length(recIdx)>0) {
      P[i,j] <- df$Rate[recIdx]
    }
  }
}

diag(P) <- 1 - rowSums(P)

N <- length(A)
for (i in N){
 ino <- A[i]
for (j in N) {
ipo <- diag(P)[i]
if(i==j){
beta[i] <- 1.2/((ino-1) * ipo)
    }
  }
}
