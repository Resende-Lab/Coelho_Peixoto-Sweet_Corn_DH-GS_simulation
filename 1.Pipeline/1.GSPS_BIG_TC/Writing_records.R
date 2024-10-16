cat(" Writing records \n")
# NOTE: Training records are collected with a sliding-window process.
# Cumulation of the records starts in the burn-in year 'startTrainPop'.
# Once the burn-in period is over, the sliding-window process removes the oldest
# records.


if(year >= startTrainPop){

  ######------------------------------------------------
  ##>>>>>  Pull population
  ######------------------------------------------------

  if (year == 12) {
    pop1 = TSPop
    pop1@fixEff <- as.integer(rep(paste0(year,1L),nInd(pop1)))

    trainPop = pop1

  } else if (year == 13 | year == 14 | year == 15 | year == 16) {

    pop1 = TSPop
    pop1@fixEff <- as.integer(rep(paste0(year,1L),nInd(pop1)))

    trainPop = c(trainPop, pop1)

  } else {

    pop1 = TSPop
    pop1@fixEff <- as.integer(rep(paste0(year,1L),nInd(pop1)))

    trainPop <- trainPop[-c(1:nInd(pop1))]
    trainPop = c(trainPop, pop1)

  }

}

