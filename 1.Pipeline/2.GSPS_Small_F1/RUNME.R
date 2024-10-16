####################################################################################
###################### AlphaSimR code for sweet corn breeding
###################### This is the first script of the simulation
####################################################################################

##>>>----------- Setting the environment
rm(list = ls())

require('AlphaSimR')

setwd("/orange/mresende/marcopxt/DH/Version2/1.Pipeline/3.GSPS")

options(echo=TRUE)
args = commandArgs(trailingOnly=TRUE)
rep <- as.numeric(args[1])
VarGE <- as.numeric(args[2])
VarE <-  as.numeric(args[3])
Parental <- as.numeric(args[4])
#rep=13;VarGE=0; VarE=240;Parental=50


# ##>>>----------- Setting the scenarios
# source("GlobalParameters.R")
# 
# # Initialize variables for results
# MeanG_pop =
# MeanP_pop =
# Accuracy =
# MeanA_pop =
# VarA_pop =
# VarG_pop =
# GenicVA_pop =
# GenicVG_pop =
# LDB_pop =
# LDW_pop =
# LDT_pop =
# covG_L_pop =
# LD_pop =
# covG_HW_pop =
# inbreeding =
# inbreedingQTL =
# matrix(NA, 35)
# 
# ###------------------------------------------------------------------------
# ###                Setting up the base population
# ###------------------------------------------------------------------------
# 
# ###>>>>----------------- Creating parents and Starting the pipeline
# # Create initial parents and set testers and hybrid parents
# source("CreatParents.R")
# 
# # Fill breeding pipeline with unique individuals from initial parents
# source("FillPipeline.R")
# 
# ###>>>>----------------- p-values for Genotype-by-environment effects
# b.f=burninYears+futureYears
# 
# # p-values for GxY effects
# Pgy = 0.5 + rnorm(b.f,0,0.03)
# 
# 
# # p-values for GxYxE effects
# Pgye1 = 0.9 + rnorm(b.f,0,0.03)
# Pgye2 = 0.1 + rnorm(b.f,0,0.03)
# Pgye = c(Pgye1,Pgye2)
# 
# Pgye = sample(Pgye,b.f, replace=F)
# 
# startTrainPop = 12
# 
# ###################################################################################
# ############# Burn-in Phase
# ###################################################################################
# 
# for(year in 1:(burninYears)){
#   cat("Working on Year:",year,"\n")
#   pgy = Pgy[year]
#   pgye = Pgye[year]
# 
#   source("UpdateParents_public.R") #Pick new parents
#   source("Burnin_cycle.R") #Advances public yield trials by a year
#   source("UpdateResults_BS.R") #Track summary data
#   source("Writing_records.R")
# 
#   source("UpdateParents_private.R") #Pick new parents and testers
#   source("Advance_cycle_private.R") #Advances private yield trials by a year
#   source("UpdateTesters.R") #Pick new testers
# 
# }
# 
# #Save burn-in to load later use
# save.image(sprintf("BurnIn_r%s_GE%s_VarE%s_Par%s.rda",rep, VarGE, VarE, Parental))
# 
# ##########################################################################################
# ############# Scenario 1 - Baseline
# ##########################################################################################
# # 1.0 Loading the scenarios
# load(sprintf("BurnIn_r%s_GE%s_VarE%s_Par%s.rda",rep, VarGE, VarE, Parental))
# 
# # 1.1 Looping through the years
# cat("Working on Scenario 1\n")
# for(year in (burninYears+1):(burninYears+futureYears)){
#   cat("Working on Year:",year,"\n")
#   pgy = Pgy[year]
#   pgye = Pgye[year]
# 
#   #Private program
#   source("UpdateParents_private.R") #Pick new parents and testers
#   source("Advance_cycle_private.R") #Advances private yield trials by a year
#   source("UpdateTesters.R") #Pick new testers
# 
# 
#   ##Scenario baseline
#   source("UpdateParents_Pheno.R") #Pick new parents
#   source("Advance_cycle_BS.R") #Advances yield trials by a year
#   source("UpdateResults_BS.R") #Track summary data
# 
# }
# 
# # 1.2 Recording results
# output1 = data.frame(rep=rep(rep, 35),
#                      scenario=rep("Pheno", 35),
#                      VarGE=rep(VarGE, 35),
#                      VarE=rep(VarE, 35),
#                      Parental=rep(Parental, 35),
#                      MeanG_pop,
#                      MeanP_pop,
#                      Accuracy,
#                      MeanA_pop,
#                      VarA_pop,
#                      VarG_pop,
#                      GenicVA_pop,
#                      GenicVG_pop,
#                      LDB_pop,
#                      LDW_pop,
#                      LDT_pop,
#                      covG_L_pop,
#                      LD_pop,
#                      covG_HW_pop,
#                      inbreeding,
#                      inbreedingQTL,
#                      stringsAsFactors=FALSE)
# 
# 
# # 1.3 Saving the results
# saveRDS(output1, paste0("Scenario_Pheno",rep,"_GE" ,VarGE,"_E",VarE,"_Par",Parental,".rds"))

##########################################################################################
############# Scenario 2 - Genomic selection 
##########################################################################################
# 2.0 Loading the scenarios
load(sprintf("BurnIn_r%s_GE%s_VarE%s_Par%s.rda",rep, VarGE, VarE, Parental))

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
    F3_public.sel = setEBV(F3_public.sel, gsModel)
    F5_public.sel = setEBV(F5_public.sel, gsModel)
  }
  
  source("UpdateParents_GS.R") #Pick new parents
  source("Advance_cycle_GS.R") #Advances yield trials by a year
  source("UpdateResults_GS.R") #Track summary data
}

# 1.2 Recording results
output2 = data.frame(rep=rep(rep, 35),
                     scenario=rep("GS", 35),
                     VarGE=rep(VarGE, 35),
                     VarE=rep(VarE, 35),
                     Parental=rep(Parental, 35),
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
                     stringsAsFactors=FALSE)


# 1.3 Saving the results
saveRDS(output2, paste0("Scenario_GS",rep,"_GE" ,VarGE,"_E",VarE,"_Par",Parental,".rds"))

# #####------------------------------ Removing the .rda files ------------------#################
# file.remove(sprintf("BurnIn_r%s_GE%s_VarE%s_Par%s.rda",rep, VarGE, VarE, Parental))

######################################### The end ##############################################





