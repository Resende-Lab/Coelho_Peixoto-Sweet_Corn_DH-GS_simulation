#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data


########-----------------  Year 1  -------------########
# Spring
F1_public = randCross(Parents_public_update, nCrosses_public, ignoreSexes = TRUE)

# Fall and Winter = Make DH
PublicDH = makeDH(F1_public, nDH = pub_DH, keepParents = FALSE) 
PublicInbredYT1 = PublicDH

########-----------------  Year 2  -------------########
# Fall
PublicInbredYT1 = setPheno(PublicInbredYT1,reps=1,p=pgye, varE = VarE) # Fall
PublicInbredYT1Sel = selectInd(PublicInbredYT1, nInd=800) # Fall
PublicHybridYT1 = hybridCross(Tester1_private, PublicInbredYT1Sel) # Fall

# Winter - target environment
PublicHybridYT1 = setPheno(PublicHybridYT1,varE=VarE, reps=repTC1, p=pgy) # Winter
PublicInbredYT1Sel@pheno = as.matrix(calcGCA(PublicHybridYT1)$GCAm[,2]) # Winter
PublicInbredYT2 = selectInd(selectWithinFam(PublicInbredYT1Sel, 4, use = "pheno"),  # Winter
                            200, use = "pheno")

########-----------------  Year 3  -------------########
# Fall
PublicHybridYT2 = hybridCross(Tester2_private, PublicInbredYT2) #Fall

# Winter - target environment
PublicHybridYT2 = setPheno(PublicHybridYT2,varE=VarE, reps=repTC2,p=pgy) # Winter
PublicInbredYT2@pheno = as.matrix(calcGCA(PublicHybridYT2)$GCAm[,2]) # Winter
PublicInbredYT3 = selectInd(PublicInbredYT2, 100, use="pheno") # Winter
PublicInbredYT2Phen = PublicInbredYT2 # Parental Selection

########-----------------  Year 4  -------------########
# fall
PublicHybridYT3 = hybridCross(Tester3_private,PublicInbredYT3) # Fall

# Winter - target environment
PublicHybridYT3 = setPheno(PublicHybridYT3,varE=VarE, reps=repTC3, p=pgy) # Winter
PublicInbredYT3@pheno = as.matrix(calcGCA(PublicHybridYT3)$GCAm[,2]) # Winter
PublicHybridYT4 = selectInd(PublicHybridYT3, 10, use="pheno") # Winter

########-----------------  Year 5  -------------########
PublicHybridYT4 = setPheno(PublicHybridYT4,varE=VarE,reps=25,p=pgy)
PublicHybridYT5 = selectInd(PublicHybridYT4, 5, use="pheno")

########-----------------  Year 6  -------------########
PublicHybridYT5 = setPheno(PublicHybridYT5,varE=VarE,reps=30,p=pgy)
Release_HybridYT5 = selectInd(PublicHybridYT5, 2, use="pheno")

# ########-----------------  Year 7  -------------########
# #Release hybrid
# 
# DHTrain1 = PublicInbredYT1Sel
# DHTrain1@pheno = as.matrix(calcGCA(PublicHybridYT1)$GCAm[,2])
# DHTrain1@fixEff <- as.integer(rep(paste0(year,1L),nInd(DHTrain1)))
# 
# DHTrain2 = PublicInbredYT2
# DHTrain2@pheno = as.matrix(aggregate(as.matrix(calcGCA(PublicHybridYT2)$GCAm[,2])~as.matrix(calcGCA(PublicHybridYT2)$GCAm[,1]), FUN=mean)[,2])
# DHTrain2@fixEff <- as.integer(rep(paste0(year,2L),nInd(DHTrain2)))
# 
# DHTrain3 = PublicInbredYT3
# DHTrain3@pheno = as.matrix(aggregate(as.matrix(calcGCA(PublicHybridYT3)$GCAm[,2])~as.matrix(calcGCA(PublicHybridYT3)$GCAm[,1]), FUN=mean)[,2])
# DHTrain3@fixEff <- as.integer(rep(paste0(year,3L),nInd(DHTrain3)))
# 
# TotPop = c(DHTrain1, DHTrain2, DHTrain3)


