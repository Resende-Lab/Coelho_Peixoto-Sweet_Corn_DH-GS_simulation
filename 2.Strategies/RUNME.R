####################################################################################
###################### AlphaSimR code for sweet corn breeding
###################### This is the first script of the simulation
####################################################################################

###>>>------------------------------------------------------------------------
###>>>---- 1.Setting up the environment and scenarios
###>>>------------------------------------------------------------------------

##>>>----------- Setting the environment
rm(list = ls())

require(AlphaSimR)

setwd("/orange/mresende/marcopxt/DH/2.Git/30") # Change here to set your wd

options(echo=TRUE)
args = commandArgs(trailingOnly=TRUE)
rep <- as.numeric(args[1])
VarGE <- as.numeric(args[2])

##>>>----------- Setting the scenarios

source("GlobalParameters.R")

# Initialize variables for results
hybridMean =
  accF3 = 
  accF5 = 
  parent_mean = 
  parent_var =
  GainHyb_perCycle =
  geneticGainHyb =
  rep(NA_real_,burninYears+futureYears)


# Empty list for public breeding program
output = list(hybridMean=NULL,
              accF3=NULL,
              accF5=NULL,
              parent_mean = NULL,
              parent_var = NULL,
              GainHyb_perCycle = NULL,
              geneticGainHyb = NULL)

# Save results
saveRDS(output,sprintf("Scenario_Conv_r%s_GE%s.rds",rep,VarGE))
saveRDS(output,sprintf("Scenario_GS_r%s_GE%s.rds",rep,VarGE))
saveRDS(output,sprintf("Scenario_DH_r%s_GE%s.rds",rep,VarGE))
saveRDS(output,sprintf("Scenario_DHGS_r%s_GE%s.rds",rep,VarGE))
saveRDS(output,sprintf("Scenario_DH4y_r%s_GE%s.rds",rep,VarGE))
saveRDS(output,sprintf("Scenario_DHGS4y_r%s_GE%s.rds",rep,VarGE))
saveRDS(output,sprintf("Scenario_DHAlt_r%s_GE%s.rds",rep,VarGE))
saveRDS(output,sprintf("Scenario_DHGSAlt_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 2.Setting up the base population
###>>>------------------------------------------------------------------------

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

###>>>------------------------------------------------------------------------
###>>>---- 3. Burn-in phase
###>>>------------------------------------------------------------------------
# Running the simulations
for(year in 1:(burninYears)){           
  cat("Working on Year:",year,"\n")                               
  pgy = Pgy[year]                                                      
  pgye = Pgye[year]
  
  source("UpdateParents_public.R") #Pick new parents
  source("Burnin_cycle.R") #Advances public yield trials by a year
  source("UpdateResults_public.R") #Track summary data
  
  
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }
}

# Save burn-in to load later use
save.image(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 4. Scenario 1 - Conventional breeding program
###>>>------------------------------------------------------------------------

# 1.0 Loading the scenarios
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 1.1 Looping through the years
cat("Working on Scenario 1\n")
for(year in (burninYears+1):(burninYears+futureYears)){            
  cat("Working on Year:",year,"\n")                   
  pgy = Pgy[year]                                                      
  pgye = Pgye[year]
  
  #Private program
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }
  
  ##Scenario baseline
  source("UpdateParents.R") #Pick new parents
  source("Advance_cycle_Conv.R") #Advances yield trials by a year
  source("UpdateResults_Conv.R") #Track summary data
  
}

# 1.2 Read the RDS
output = readRDS(sprintf("Scenario_Conv_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 1.3 Saving the results
saveRDS(output, sprintf("Scenario_Conv_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 5. Scenario 2 - Genomic selection breeding program
###>>>------------------------------------------------------------------------

# 2.0 Loading the Burn-in
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 2.1 Looping through the years
cat("Working on Scenario 2\n")
for(year in (burninYears+1):(burninYears+futureYears)){            
  cat("Working on Year:",year,"\n")                   
  pgy = Pgy[year]                                                      
  pgye = Pgye[year]
  
  
  #Private program
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
 
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }
  
  
  ###Scenario GS
  
    if(year==(burninYears+1)){
    gsModel = RRBLUP(c(F1_public,F2_public), use = "pheno", snpChip = 1)
    F3_public.ebv = setEBV(F3_public.s0,gsModel) # Winter (genotyping the leaves)
    F3_public.sel = selectWithinFam(F3_public.ebv, nInd = 2, selectTop = TRUE,use="ebv") # Fall
    
    F5_public.ebv = setEBV(F5_public.s0,gsModel) # Fall (genotyping the leaves)
    F5_public.sel = selectWithinFam(F5_public.ebv, nInd = 1, selectTop = TRUE,use="ebv") # Fall
    F5_public.sel = selectInd(F5_public.sel, nInd = 150, selectTop = TRUE, use="ebv") # Winter
    
  }
  
  source("UpdateParents_GS.R") #Pick new parents
  source("Advance_cycle_GS.R") #Advances yield trials by a year
  source("UpdateResults_GS.R") #Track summary data
  
}

# 2.2 Read the RDS
output = readRDS(sprintf("Scenario_GS_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 2.3 Saving the results
saveRDS(output, sprintf("Scenario_GS_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 6. Scenario 3 - Doubled-haploid breeding program
###>>>------------------------------------------------------------------------
# 3.0 Loading the Burn-in
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 3.1 Looping through the years
cat("Working on Scenario 3\n")
for(year in (burninYears+1):(burninYears+futureYears)){            
  cat("Working on Year:",year,"\n") 
  
  pgy = Pgy[year]                                                      
  pgye = Pgye[year]
  
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }
  
  if(year==(burninYears+1)){
    DH_Pub1=makeDH(F1_public, nDH = pub_DH, keepParents = FALSE)
    TC3_DH=TC2_DH=TC1_DH=DH_Pub3=DH_Pub2=DH_Pub1
    gsModel = RRBLUP(F1_public, use = "pheno", snpChip = 1)
  }
  
  source("UpdateParents.DH.R") #Pick new parents
  source("Advance_cycle.DH.R") #Advances yield trials by a year
  source("UpdateResults.DH.R") #Track summary data
  
}

# 3.2 Read the RDS
output = readRDS(sprintf("Scenario_DH_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 3.3 Saving the results
saveRDS(output,sprintf("Scenario_DH_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 6. Scenario 4 - Doubled-haploid breeding program + Genomic selection
###>>>------------------------------------------------------------------------

# 4.0 Loading the Burn-in
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 4.1 Looping through the years
cat("Working on Scenario 4\n")
for(year in (burninYears+1):(burninYears+futureYears)){            
  cat("Working on Year:",year,"\n") 
  
  pgy = Pgy[year]                                                      
  pgye = Pgye[year]
  
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }
  
  if(year==(burninYears+1)){
    DH_Pub1=makeDH(F1_public, nDH = pub_DH, keepParents = FALSE)
    TC3_DH=TC2_DH=TC1_DH=DH_Pub3=DH_Pub2=DH_Pub1
    gsModel = RRBLUP(F1_public, use = "pheno", snpChip = 1)
  }
  
  source("UpdateParents.DH.R") #Pick new parents
  source("Advance_cycle.DHGS.R") #Advances yield trials by a year
  source("UpdateResults.DHGS.R") #Track summary data
  
}


# 4.2 Read the RDS
output = readRDS(sprintf("Scenario_DHGS_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 4.3 Saving the results
saveRDS(output,sprintf("Scenario_DHGS_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 6. Scenario 5 - Doubled-haploid breeding program (4 years)
###>>>------------------------------------------------------------------------

# 5.0 Loading the Burn-in
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 5.1 Looping through the years
cat("Working on Scenario 5\n")
for(year in (burninYears+1):(burninYears+futureYears)){
  cat("Working on Year:",year,"\n")

  pgy = Pgy[year]
  pgye = Pgye[year]

  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }

  if(year==(burninYears+1)){
    DH_Pub1=makeDH(F1_public, nDH = pub_DH, keepParents = FALSE)
    TC3_DH=TC2_DH=TC1_DH=DH_Pub3=DH_Pub2=DH_Pub1
    }

  source("UpdateParents.DH.R") #Pick new parents
  source("Advance_cycle.DH4y.R") #Advances yield trials by a year
  source("UpdateResults.DH4y.R") #Track summary data

}

# 5.2 Read the RDS
output = readRDS(sprintf("Scenario_DH4y_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 5.3 Saving the results
saveRDS(output,sprintf("Scenario_DH4y_r%s_GE%s.rds",rep,VarGE))


###>>>------------------------------------------------------------------------
###>>>---- 6. Scenario 6 - Doubled-haploid breeding program + Genomic selection (4 years)
###>>>------------------------------------------------------------------------

# 6.0 Loading the Burn-in
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 6.1 Looping through the years
cat("Working on Scenario 6\n")
for(year in (burninYears+1):(burninYears+futureYears)){
  cat("Working on Year:",year,"\n")

  pgy = Pgy[year]
  pgye = Pgye[year]

  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }

  if(year==(burninYears+1)){
    DH_Pub1=makeDH(F1_public, nDH = pub_DH, keepParents = FALSE)
    TC3_DH=TC2_DH=TC1_DH=DH_Pub3=DH_Pub2=DH_Pub1
    gsModel = RRBLUP(F1_public, use = "pheno", snpChip = 1)
  }

  source("UpdateParents.DH.R") #Pick new parents
  source("Advance_cycle.DHGS4y.R") #Advances yield trials by a year
  source("UpdateResults.DHGS4y.R") #Track summary data

}


# 6.2 Read the RDS
output = readRDS(sprintf("Scenario_DHGS4y_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 6.3 Saving the results
saveRDS(output,sprintf("Scenario_DHGS4y_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 6. Scenario 7 - Doubled-haploid breeding program alternative
###>>>------------------------------------------------------------------------

# 7.0 Loading the Burn-in
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 7.1 Looping through the years
cat("Working on Scenario 7\n")
for(year in (burninYears+1):(burninYears+futureYears)){
  cat("Working on Year:",year,"\n")
  
  pgy = Pgy[year]
  pgye = Pgye[year]
  
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }
  
  if(year==(burninYears+1)){
    DH_Pub1=makeDH(F1_public, nDH = pub_DH, keepParents = FALSE)
    TC3_DH=TC2_DH=TC1_DH=DH_Pub3=DH_Pub2=DH_Pub1
  }
  
  source("UpdateParents.DH.R") #Pick new parents
  source("Advance_cycle.DHAlt.R") #Advances yield trials by a year
  source("UpdateResults.DH.R") #Track summary data
  
}

# 7.2 Read the RDS
output = readRDS(sprintf("Scenario_DHAlt_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 7.3 Saving the results
saveRDS(output,sprintf("Scenario_DHAlt_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- 6. Scenario 8 - Doubled-haploid breeding program alternative plus GS
###>>>------------------------------------------------------------------------

# 8.0 Loading the Burn-in
load(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))

# 8.1 Looping through the years
cat("Working on Scenario 8\n")
for(year in (burninYears+1):(burninYears+futureYears)){
  cat("Working on Year:",year,"\n")
  
  pgy = Pgy[year]
  pgye = Pgye[year]
  
  
  source("UpdateParents_private.R") #Pick new parents and testers
  source("Advance_cycle_private.R") #Advances private yield trials by a year
  
  if ((year %% 1)==0){
    source("UpdateTesters.R") #Pick new testers
  }
  
  if(year==(burninYears+1)){
    DH_Pub1=makeDH(F1_public, nDH = pub_DH, keepParents = FALSE)
    TC3_DH=TC2_DH=TC1_DH=DH_Pub3=DH_Pub2=DH_Pub1
    gsModel = RRBLUP(F1_public, use = "pheno", snpChip = 1)
  }
  
  source("UpdateParents.DH.R") #Pick new parents
  source("Advance_cycle.DHGSAlt.R") #Advances yield trials by a year
  source("UpdateResults.DHGS.R") #Track summary data
  
}

# 8.2 Read the RDS
output = readRDS(sprintf("Scenario_DHGSAlt_r%s_GE%s.rds",rep,VarGE))
output = list(hybridMean=rbind(output$hybridMean,hybridMean),
              accF3=rbind(output$accF3,accF3),
              accF5=rbind(output$accF5,accF5),
              parent_mean=rbind(output$parent_mean,parent_mean),
              parent_var=rbind(output$parent_var,parent_var),
              GainHyb_perCycle=rbind(output$GainHyb_perCycle,GainHyb_perCycle))

# 8.3 Saving the results
saveRDS(output,sprintf("Scenario_DHGSAlt_r%s_GE%s.rds",rep,VarGE))

###>>>------------------------------------------------------------------------
###>>>---- Removing the .rda files
###>>>------------------------------------------------------------------------

file.remove(sprintf("tmp_r%s_GE%s.rda",rep,VarGE))


######################################### The end ##############################################





