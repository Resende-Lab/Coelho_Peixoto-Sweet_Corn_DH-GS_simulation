#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

# ########-----------------  Year 7  -------------########
# #Release hybrid
# 
# ########-----------------  Year 6  -------------########
# PublicHybridYT5 = setPheno(PublicHybridYT5,varE=VarE,reps=30,p=pgy)
# Release_HybridYT5 = selectInd(PublicHybridYT5, 2, use="pheno")
# 
# ########-----------------  Year 5  -------------########
# PublicHybridYT4 = setPheno(PublicHybridYT4,varE=VarE,reps=25,p=pgy)
# PublicHybridYT5 = selectInd(PublicHybridYT4, 5, use="pheno")

########-----------------  Year 4  -------------########
# fall - off-season environment
PublicHybridYT3 = hybridCross(Tester3_private,PublicInbredYT3, crossPlan = "testcross") # Fall

# Winter - target environment
PublicHybridYT3 = setPheno(PublicHybridYT3,varE=VarE, reps=repTC3, p=pgy) # Winter
PublicInbredYT3@pheno = as.matrix(calcGCA(PublicHybridYT3)$GCAm[,2]) # Winter
PublicHybridYT4 = selectInd(PublicHybridYT3, 2*nBIG, use="pheno") # Winter

HybridMean = PublicHybridYT4

DHTrain3 = PublicInbredYT3
DHTrain3@pheno = as.matrix(aggregate(as.matrix(calcGCA(PublicHybridYT3)$GCAm[,2])~as.matrix(calcGCA(PublicHybridYT3)$GCAm[,1]), FUN=mean)[,2])

########-----------------  Year 3  -------------########
# Fall - off-season environment
PublicHybridYT2 = hybridCross(Tester2_private, PublicInbredYT2, crossPlan = "testcross") #Fall

# Winter - target environment
PublicHybridYT2 = setPheno(PublicHybridYT2, varE=VarE, reps=repTC2, p=pgy) # Winter
PublicInbredYT2@pheno = as.matrix(calcGCA(PublicHybridYT2)$GCAm[,2]) # Winter

PublicInbredYT2 = setEBV(PublicInbredYT2, gsModel)
PublicInbredYT3 = selectInd(PublicInbredYT2, 20*nBIG, use="ebv") # Winter

DHTrain2 = PublicInbredYT2
DHTrain2@pheno = as.matrix(aggregate(as.matrix(calcGCA(PublicHybridYT2)$GCAm[,2])~as.matrix(calcGCA(PublicHybridYT2)$GCAm[,1]), FUN=mean)[,2])

########-----------------  Year 2  -------------########
# Fall - off-season environment
PublicHybridYT1 = hybridCross(Tester1_private, PublicInbredYT1Sel, crossPlan = "testcross") # Fall

# Winter - target environment
PublicHybridYT1 = setPheno(PublicHybridYT1, varE=VarE, reps=repTC1, p=pgy) # Winter
PublicInbredYT1Sel@pheno = as.matrix(calcGCA(PublicHybridYT1)$GCAm[,2]) # Winter

PublicInbredYT1Sel = setEBV(PublicInbredYT1Sel, gsModel)
PublicInbredYT2 = selectInd(PublicInbredYT1Sel, 150*nBIG, use = "ebv") # Winter
                            
DHTrain1 = PublicInbredYT1Sel

########-----------------  Year 1  -------------########
# Spring
F1_public = randCross(Parents_public_update, nCrosses_public*nBIG, ignoreSexes = TRUE)

# Fall and Winter = Make DH
PublicDH = makeDH(F1_public, nDH = pub_DH, keepParents = FALSE) 
PublicInbredYT1 = PublicDH

#--- GS model
gsModel = RRBLUP(trainPop, use = "pheno", snpChip = 1, useReps = TRUE) # Winter

PublicInbredYT1 = setEBV(PublicInbredYT1, gsModel)
PublicInbredYT1Sel = selectInd(PublicInbredYT1, nInd=800*nBIG, use = 'ebv') # Fall

