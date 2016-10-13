setwd("C:/Users/Dr M/Desktop")
list.files()
dataframe <- fromJSON(file = 'mondaymodel.json')
dataframe$trajectories[[2]]$S
dataframe$trajectories[[1]]$S[[2]]
lines(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$S[[2]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "green",
main = "SIR Model for Influenza spread in New Zealand")
legend(22,300000, c("Infected", "Susceptible", "Recovered"), pch = 0, col = 2:4, bty = "n")

dataframe$trajectories[[1]]$t
dataframe$trajectories[[1]]$I
dataframe$trajectories[[1]]$I[[2]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$I[[2]],'s',
xlab = "Time(weeks)", ylab = "Population size",
main = " ",col = "red")

dataframe$trajectories[[1]]$R
dataframe$trajectories[[1]]$R[[2]]
lines(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$R[[2]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "blue",
main = " ")

dataframe <- fromJSON(file = 'newmodel.json')
dataframe$trajectories[[1]]$S
dataframe$trajectories[[1]]$S[[0]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$S[[0]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "green",
main = "SIR Model for Influenza spread in New Zealand")
legend(6.5,3000000, c("Infected", "Susceptible", "Recovered"), pch = 0, col = 2:4, bty = "n")

dataframe$trajectories[[1]]$t
dataframe$trajectories[[1]]$I
dataframe$trajectories[[1]]$I[[0]]
lines(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$I[[0]],'s',
xlab = "Time(weeks)", ylab = "Population size",
main = " ",col = "red")

dataframe$trajectories[[1]]$R
dataframe$trajectories[[1]]$R[[0]]
lines(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$R[[0]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "blue",
main = " ")
