####################################################################################
###################### AlphaSimR code for sweet corn breeding
###################### This is the first script of the simulation
####################################################################################

##>>>----------- Setting the environment
rm(list = ls())

require('AlphaSimR')

setwd("...") #*** set working directory here

options(echo=TRUE)
args = commandArgs(trailingOnly=TRUE)
rep <- as.numeric(args[1])
VarGE <- as.numeric(args[2])
VarE <-  as.numeric(args[3])


##>>>----------- Setting the scenarios
source("GlobalParameters.R")

# Initialize variables for results
MeanG_pop =
MeanP_pop =
Accuracy =
MeanA_pop =
VarA_pop =
VarG_pop =
GenicVA_pop =
GenicVG_pop =
LDB_pop =
LDW_pop =
LDT_pop =
covG_L_pop =
LD_pop =
covG_HW_pop =
inbreeding =
inbreedingQTL =
HBMean =
matrix(NA, 35)

###------------------------------------------------------------------------
###                Setting up the base population
###------------------------------------------------------------------------

###>>>>----------------- Creating parents and Starting the pipeline
# Create initial parents and set testers and hybrid parents
source("CreatParents.R")

# Fill breeding pipeline with unique individuals from initial parents
source("FillPipeline.R")

###>>>>----------------- p-values for Genotype-by-environment effects
b.f=burninYears+futureYears

# p-values for GxY effects
Pgy = 0.5 + rnorm(b.f,0,0.03)


# p-values for GxYxE effects
Pgye1 = 0.9 + rnorm(b.f,0,0.03)
Pgye2 = 0.1 + rnorm(b.f,0,0.03)
Pgye = c(Pgye1,Pgye2)

Pgye = sample(Pgye,b.f, replace=F)

startTrainPop = 12

###################################################################################
############# Burn-in Phase
###################################################################################

for(year in 1:(burninYears)){
  cat("Working on Year:",year,"\n")
  pgy = Pgy[year]
  pgye = Pgye[year]

  source("UpdateParents_public.R") #Pick new parents
  source("Burnin_cycle.R") #Advances public yield trials by a year
  source("UpdateResults.BS.R") #Track summary data
  source("Writing_records.R")

  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  source("UpdateTesters.R") #Pick new testers
}

#Save burn-in to load later use
save.image(sprintf("BurnIn_r%s_GE%s_VarE%s.rda",rep, VarGE, VarE))

##########################################################################################
############# Scenario 1 - Baseline
##########################################################################################
# 1.0 Loading the scenarios
load(sprintf("BurnIn_r%s_GE%s_VarE%s.rda",rep, VarGE, VarE))

# 1.1 Looping through the years
cat("Working on Scenario 1\n")
for(year in (burninYears+1):(burninYears+futureYears)){
  cat("Working on Year:",year,"\n")
  pgy = Pgy[year]
  pgye = Pgye[year]


  #Private program
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  source("UpdateTesters.R") #Pick new testers

  ##Scenario baseline
  source("UpdateParents_Pheno.R") #Pick new parents
  source("Advance_cycle_BS.R") #Advances yield trials by a year
  source("UpdateResults.BS.R") #Track summary data

}

# 1.2 Recording results
output1 = data.frame(rep=rep(rep, 35),
                     scenario=rep("Pheno", 35),
                     VarGE=rep(VarGE, 35),
                     VarE=rep(VarE, 35),
                     MeanG_pop,
                     MeanP_pop,
                     Accuracy,
                     MeanA_pop,
                     VarA_pop,
                     VarG_pop,
                     GenicVA_pop,
                     GenicVG_pop,
                     LDB_pop,
                     LDW_pop,
                     LDT_pop,
                     covG_L_pop,
                     LD_pop,
                     covG_HW_pop,
                     inbreeding,
                     inbreedingQTL,
                     HBMean,
                     stringsAsFactors=FALSE)


# 1.3 Saving the results
saveRDS(output1, paste0("Scenario_Pheno",rep,"_GE" ,VarGE,"_E",VarE,".rds"))

##########################################################################################
############# Scenario 2 - Genomic selection
##########################################################################################
# 2.0 Loading the scenarios
load(sprintf("BurnIn_r%s_GE%s_VarE%s.rda",rep, VarGE, VarE))

# 2.1 Looping through the years
cat("Working on Scenario 2\n")
for(year in (burninYears+1):(burninYears+futureYears)){
  cat("Working on Year:",year,"\n")
  pgy = Pgy[year]
  pgye = Pgye[year]


  #Private program
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  source("UpdateTesters.R") #Pick new testers


 ###Scenario GS

  if(year==(burninYears+1)){
    # GS model
    gsModel = RRBLUP(trainPop, use = "pheno", snpChip = 1, useReps = TRUE)

    #Parents
    Parents_public_update = setEBV(Parents_public_update,gsModel)
    F5_public.sel = setEBV(F5_public.sel, gsModel)
  }

  source("UpdateParents_GS.R") #Pick new parents
  source("Advance_cycle_GS.R") #Advances yield trials by a year
  source("UpdateResults.GS.R") #Track summary data
  source("Writing_records.R")

  cat(table(trainPop@fixEff), '\n')
  cat(names(table(trainPop@fixEff)), '\n')

  }

# 2.2 Recording results
output2 = data.frame(rep=rep(rep, 35),
                     scenario=rep("GS", 35),
                     VarGE=rep(VarGE, 35),
                     VarE=rep(VarE, 35),
                     MeanG_pop,
                     MeanP_pop,
                     Accuracy,
                     MeanA_pop,
                     VarA_pop,
                     VarG_pop,
                     GenicVA_pop,
                     GenicVG_pop,
                     LDB_pop,
                     LDW_pop,
                     LDT_pop,
                     covG_L_pop,
                     LD_pop,
                     covG_HW_pop,
                     inbreeding,
                     inbreedingQTL,
                     HBMean,
                     stringsAsFactors=FALSE)


# 2.3 Saving the results
saveRDS(output2, paste0("Scenario_GS",rep,"_GE" ,VarGE,"_E",VarE,".rds"))


##########################################################################################
############# Scenario 3 - DH scenario
##########################################################################################
# 3.0 Loading the scenarios
load(sprintf("BurnIn_r%s_GE%s_VarE%s.rda",rep, VarGE, VarE))

# 3.1 Looping through the years
cat("Working on Scenario 3\n")
for(year in (burninYears+1):(burninYears+futureYears)){
  cat("Working on Year:",year,"\n")
  pgy = Pgy[year]
  pgye = Pgye[year]

  #Private program
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  source("UpdateTesters.R") #Pick new testers

  if(year==(burninYears+1)){
    source('fillDH.R')
  }

  source("UpdateParents_DH.R") #Pick new parents
  source("Advance_cycle.DH.R") #Advances yield trials by a year
  source("UpdateResults.BS.R") #Track summary data
 }

# 3.2 Recording results
output3 = data.frame(rep=rep(rep, 35),
                     scenario=rep("DH", 35),
                     VarGE=rep(VarGE, 35),
                     VarE=rep(VarE, 35),
                     MeanG_pop,
                     MeanP_pop,
                     Accuracy,
                     MeanA_pop,
                     VarA_pop,
                     VarG_pop,
                     GenicVA_pop,
                     GenicVG_pop,
                     LDB_pop,
                     LDW_pop,
                     LDT_pop,
                     covG_L_pop,
                     LD_pop,
                     covG_HW_pop,
                     inbreeding,
                     inbreedingQTL,
                     HBMean,
                     stringsAsFactors=FALSE)

# 3.3 Saving the results
saveRDS(output3, paste0("Scenario_DH",rep,"_GE" ,VarGE,"_E",VarE,".rds"))


##########################################################################################
############# Scenario 4 - DHGS scenario
##########################################################################################
# 4.0 Loading the scenarios
load(sprintf("BurnIn_r%s_GE%s_VarE%s.rda",rep, VarGE, VarE))

# 4.1 Looping through the years
cat("Working on Scenario 4\n")
for(year in (burninYears+1):(burninYears+futureYears)){            
  cat("Working on Year:",year,"\n")                   
  pgy = Pgy[year]                                                      
  pgye = Pgye[year]
  
  #Private program
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  source("UpdateTesters.R") #Pick new testers
  
  if(year==(burninYears+1)){
    #Fill DH
    source('fillDH.R')
    
    #--- GS model
    gsModel = RRBLUP(trainPop, use = "pheno", snpChip = 1) # Winter
    
    PublicInbredYT1 = setEBV(PublicInbredYT1, gsModel)
    PublicInbredYT1Sel = selectInd(PublicInbredYT1, nInd=800*nBIG, use = 'ebv') # Fall
    
    PublicInbredYT1Sel = setEBV(PublicInbredYT1Sel, gsModel)
    PublicInbredYT2 = selectInd(PublicInbredYT1Sel, 150*nBIG, use = "ebv") # Winter
    
    PublicInbredYT2 = setEBV(PublicInbredYT2, gsModel)
    PublicInbredYT3 = selectInd(PublicInbredYT2, 20*nBIG, use="ebv") # Winter
    
    Parents_public_update = setEBV(Parents_public_update, gsModel)
    }

  source("UpdateParents_DHGS.R") #Pick new parents
  source("Advance_cycle.DHGS.R") #Advances yield trials by a year
  source("UpdateResults.GS.R") #Track summary data
  source("Writing_records_DH.R")

}

# 4.2 Recording results
output4 = data.frame(rep=rep(rep, 35),
                     scenario=rep("DHGS", 35),
                     VarGE=rep(VarGE, 35),
                     VarE=rep(VarE, 35),
                     MeanG_pop,
                     MeanP_pop,
                     Accuracy,
                     MeanA_pop,
                     VarA_pop,
                     VarG_pop,
                     GenicVA_pop,
                     GenicVG_pop,
                     LDB_pop,
                     LDW_pop,
                     LDT_pop,
                     covG_L_pop,
                     LD_pop,
                     covG_HW_pop,
                     inbreeding,
                     inbreedingQTL,
                     HBMean,
                     stringsAsFactors=FALSE)

# 4.3 Saving the results
saveRDS(output4, paste0("Scenario_DHGS",rep,"_GE" ,VarGE,"_E",VarE,".rds"))


#####------------------------------ Removing the .rda files ------------------#################

file.remove(sprintf("BurnIn_r%s_GE%s_VarE%s.rda",rep, VarGE, VarE))

######################################### The end ##############################################





