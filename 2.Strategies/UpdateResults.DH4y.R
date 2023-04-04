#####-----------------------------------------------
#Track population, hybrid and parents performances
#####-----------------------------------------------

##>>--- 1. Hybrid mean
hybridMean[year] = meanG(Hybrid)

##>>--- 2. Parents mean and variance
parent_mean[year] = meanG(Parents_public_update)
parent_var[year] = varG(Parents_public_update)

##>>--- 3. Accuracy
accF3[year] = cor(DH_Pub2@gv,DH_Pub2@pheno)
accF5[year] = cor(DH_Pub2@gv,DH_Pub2@pheno)

##>>--- 4. Hybrid per number of cycles
geneticGainHyb[year] = hybridMean[year]-hybridMean[burninYears]
GainHyb_perCycle[year] = geneticGainHyb[year]/4





