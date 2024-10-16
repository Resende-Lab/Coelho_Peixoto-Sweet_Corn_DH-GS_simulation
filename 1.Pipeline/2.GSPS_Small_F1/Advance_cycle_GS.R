################################################################################################
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data
################################################################################################

######------------------------------  Year 5  ---------------------------------------#######
F10_public = self(F9_public.sel, nProgeny = 1, parents = NULL, keepParents = FALSE) # Fall
TC3 = hybridCross(F9_public.sel, Tester3_private,crossPlan = "testcross") # Fall

PublicHybrid_TC3 = setPheno(TC3, reps=repTC3,varE = VarE, p=pgy) # Winter
F9_public.sel@pheno = as.matrix(calcGCA(PublicHybrid_TC3)$GCAf[,2])

F11_public = self(F10_public, nProgeny = 1, parents = NULL, keepParents = FALSE) # Winter
F9_public.TC = selectInd(F9_public.sel,nInd=2, selectTop = TRUE) # Winter
F10_public.sel = F10_public[F10_public@mother%in%F9_public.TC@id]
F11_public.sel = F11_public[F11_public@mother%in%F10_public.sel@id] # Winter

######------------------------------  Year 4  ---------------------------------------#######
F7_public.sel = F7_public.s0
F8_public = self(F7_public.sel, nProgeny = 1, parents = NULL, keepParents = FALSE) # Fall
TC2 = hybridCross(F7_public.sel, Tester2_private,crossPlan = "testcross") # Fall

PublicHybrid_TC2 = setPheno(TC2, reps=repTC2,varE = VarE, p=pgy) # Winter
F7_public.sel@pheno = as.matrix(calcGCA(PublicHybrid_TC2)$GCAf[,2])

F9_public = self(F8_public, nProgeny = 1, parents = NULL, keepParents = FALSE) # Winter
F7_public.TC = selectInd(F7_public.sel, nInd=15, selectTop = TRUE) # Winter
F8_public.sel = F8_public[F8_public@mother%in%F7_public.TC@id]
F9_public.sel = F9_public[F9_public@mother%in%F8_public.sel@id] # Winter

######------------------------------  Year 3  ---------------------------------------#######
F5_public2TC = F5_public.sel
F6_public = self(F5_public2TC, nProgeny = 3, parents = NULL, keepParents = FALSE) # Fall
TC1 = hybridCross(F5_public2TC, Tester1_private,crossPlan = "testcross") # Fall

PublicHybrid_TC1 = setPheno(TC1, reps=repTC1,varE = VarE, p=pgy) # Winter
F5_public2TC@pheno = as.matrix(calcGCA(PublicHybrid_TC1)$GCAf[,2])
F5_public.TC = selectInd(F5_public2TC,nInd=100, selectTop = TRUE) # Winter
F7_public = self(F6_public, nProgeny = 1, parents = NULL, keepParents = FALSE) # Winter
F6_public.s0 = F6_public[F6_public@mother%in%F5_public.TC@id] # winter
F6_public.sel = selectWithinFam(F6_public.s0, nInd = 1, selectTop = TRUE) # winter
F7_public.s0 = F7_public[F7_public@mother%in%F6_public.sel@id] # winter

###### ---------------------------------- Year 2  ---------------------------------------#######
F4_public = self(F3_public.sel, nProgeny = 4, parents = NULL, keepParents = FALSE) # Fall
F5_public = self(F4_public, nProgeny = 4, parents = NULL, keepParents = FALSE) # Winter
F4_public.s0 = setPheno(F4_public,reps=2, p=pgy, varE = VarE) # Winter
F4_public.sel = selectWithinFam(F4_public.s0, nInd = 2, selectTop = TRUE) # Winter
F4_public.sel = selectInd(F4_public.sel, nInd = 300, selectTop = TRUE) # Winter
F5_public.s0 = F5_public[F5_public@mother%in%F4_public.sel@id]

F5_public.ebv = setEBV(F5_public.s0,gsModel) # (genotyping the leaves)
F5_public.sel = selectWithinFam(F5_public.ebv, nInd = 1, selectTop = TRUE, use="ebv") #
F5_public.sel = selectInd(F5_public.sel, nInd = 150, selectTop = TRUE, use="ebv") # Winter

###### ---------------------------------- Year 1  ---------------------------------------#######
### Advance population
F1_public = randCross(Parents_public_update, nCrosses_public, ignoreSexes = TRUE) # Spring
F2_public = self(F1_public, nProgeny = 10, parents = NULL, keepParents = FALSE) # Fall

F3_public = self(F2_public, nProgeny = 12, parents = NULL, keepParents = FALSE) # Winter
F2_public = setPheno(F2_public,reps=2, p=pgy, varE = VarE) # Winter
F2_public.sel = selectWithinFam(F2_public, nInd = 4, selectTop = TRUE) # Winter
F3_public.s0 = F3_public[F3_public@mother%in%F2_public.sel@id] # Winter


#GS model
F1_Total = randCross(Parents_public_update, 800, ignoreSexes = TRUE) # Spring
TSPop = setPheno(F1_Total, reps = 4, p = pgy, varE = VarE) #For training the model

source('Writing_records.R')

gsModel = RRBLUP(trainPop, snpChip = 1, useReps = TRUE)

F3_public.ebv = setEBV(F3_public.s0,gsModel) # Winter (genotyping the leaves)
F3_public.sel = selectWithinFam(F3_public.ebv, nInd = 2, selectTop = TRUE, use="ebv") # Fall


