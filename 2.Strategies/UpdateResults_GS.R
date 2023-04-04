#####-----------------------------------------------
#Track population, hybrid and parents performances
#####-----------------------------------------------

##>>--- 1. Hybrid mean
hybridMean[year] = meanG(Hybrid)

##>>--- 2. Parents mean and variance
parent_mean[year] = meanG(Parents_public_update)
parent_var[year] = varG(Parents_public_update)

##>>--- 3. Accuracy of the genomic selection
accF5[year] = cor(F5_public.ebv@gv,F5_public.ebv@ebv)
accF3[year] = cor(F3_public.ebv@gv,F3_public.ebv@ebv)

##>>--- 4. Hybrid per number of cycles
geneticGainHyb[year] = hybridMean[year]-hybridMean[burninYears]
GainHyb_perCycle[year] = geneticGainHyb[year]/5

