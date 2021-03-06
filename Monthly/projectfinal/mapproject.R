x<- c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr", "tmap")
install.packages(x)
lapply(x, library, character.only = TRUE)
getwd()
setwd("C:/Users/Dr M/Desktop/RTO_boundaries_true")
list.files()
library(rgdal)
rtomap <- readOGR(".", layer = "RTO_boundaries_true")
plot(rtomap, main = " ", col = c("red","green","blue"))
rtomapnames <- rtomap@data[-1, ]
is.character(rtomapnames)
newRTOnames <- as.character(rtomapnames)
plot(rtomap, col = c('red','green','blue'), main = ' ')

setwd("C:/Users/Dr M/Desktop")
library(rjson)
dataframe <- fromJSON(file = 'newmodel.json')
dataframe$trajectories[[1]]$I[[1]]
######################################
df <- read.csv(file = 'RTODATA.csv', as.is=T)
df
df <- df[!grepl("Area Outside RTO", df$Home_RTO),]
df <- df[!grepl("Area Outside RTO", df$RTO),]
df <- df[!grepl("NULL", df$RTO),]
RTO_Names <- unique(df$RTO)
######################################
k <- length(newRTOnames)
mapcolors <- NULL
time <- 2
timeIdx <- max(which(dataframe$trajectories[[1]]$t<time))
for (i in 1:k) {
    thisRTOname <- newRTOnames[i]
    thisRTOindex <- which(RTO_Names == thisRTOname)

    rtoPrevalence <- dataframe$trajectories[[1]]$I[[thisRTOindex]][timeIdx]
    rtoPopSize <- rtoPrevalence +
                  dataframe$trajectories[[1]]$S[[thisRTOindex]][timeIdx] +
                  dataframe$trajectories[[1]]$R[[thisRTOindex]][timeIdx]

    if (!is.finite(relPrevalence)) {
      print(rtoPopSize)
      print(thisRTOname)
      print(thisRTOindex)
    }
    relPrevalence <- rtoPrevalence/rtoPopSize
    mapcolors[i] <- rgb(1, 1-relPrevalence, 1-relPrevalence)
}
plot(rtomap, col = mapcolors)









library(tmap)
vignette(package = "tmap")
vignette("tmap-nutshell")
qtm(shp = rtomap, fill = "NAME", fill.palette = "-Greens")
