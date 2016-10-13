dataframe <- fromJSON(file = 'tuesdaymodel.json')
dataframe$trajectories[[1]]$S
dataframe$trajectories[[1]]$S[[1]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$S[[1]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "green")

dataframe$trajectories[[1]]$t
dataframe$trajectories[[1]]$I
dataframe$trajectories[[1]]$I[[1]]
lines(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$I[[1]],'s',
xlab = "Time(weeks)", ylab = "Population size",
main = " ",col = "red")

dataframe$trajectories[[1]]$R
dataframe$trajectories[[1]]$R[[1]]
lines(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$R[[1]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "blue",
main = " ")
################################################################################
dataframe <- fromJSON(file = 'fridayevening.json')
dataframe$trajectories[[1]]$S
dataframe$trajectories[[1]]$S[[5]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$S[[5]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "green")

dataframe$trajectories[[1]]$t
dataframe$trajectories[[1]]$I
dataframe$trajectories[[1]]$I[[5]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$I[[5]],'s',
xlab = "Time(weeks)", ylab = "Population size",
main = " ",col = "red")

dataframe$trajectories[[1]]$R
dataframe$trajectories[[1]]$R[[5]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$R[[5]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "blue",
main = " ")

################################################################################
dataframe <- fromJSON(file = 'fiordland.json')
dataframe$trajectories[[1]]$S
dataframe$trajectories[[1]]$S[[13]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$S[[13]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "green")

dataframe$trajectories[[1]]$t
dataframe$trajectories[[1]]$I
dataframe$trajectories[[1]]$I[[13]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$I[[13]],'s',
xlab = "Time(weeks)", ylab = "Population size",
main = " ",col = "red")

dataframe$trajectories[[1]]$R
dataframe$trajectories[[1]]$R[[13]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$R[[13]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "blue",
main = " ")
