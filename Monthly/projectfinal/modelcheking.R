dataframe <- fromJSON(file = 'fridayevening.json')
dataframe$trajectories[[1]]$S
dataframe$trajectories[[1]]$S[[1]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$S[[1]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "green")

dataframe$trajectories[[1]]$t
dataframe$trajectories[[1]]$I
dataframe$trajectories[[1]]$I[[1]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$I[[1]],'s',
xlab = "Time(weeks)", ylab = "Population size",
main = " ",col = "red")

dataframe$trajectories[[1]]$R
dataframe$trajectories[[1]]$R[[1]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$R[[1]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "blue",
main = " ")
################################################################################
dataframe <- fromJSON(file = 'fridaymodel.json')
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
dataframe <- fromJSON(file = 'fridaymodel.json')
dataframe$trajectories[[1]]$S
dataframe$trajectories[[1]]$S[[30]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$S[[30]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "green")

dataframe$trajectories[[1]]$t
dataframe$trajectories[[1]]$I
dataframe$trajectories[[1]]$I[[30]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$I[[30]],'s',
xlab = "Time(weeks)", ylab = "Population size",
main = " ",col = "red")

dataframe$trajectories[[1]]$R
dataframe$trajectories[[1]]$R[[30]]
plot(dataframe$trajectories[[1]]$t,dataframe$trajectories[[1]]$R[[30]],'s',
xlab = "Time(weeks)", ylab = "Population Size",col = "blue",
main = " ")
