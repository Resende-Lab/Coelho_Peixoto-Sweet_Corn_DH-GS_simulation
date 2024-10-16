###---------
# Choosing the best lines to update the crossing blocks
###---------

PublicInbredYT2Phen@pheno = as.matrix(aggregate(as.matrix(calcGCA(PublicHybridYT2)$GCAm[,2])~as.matrix(calcGCA(PublicHybridYT2)$GCAm[,1]), FUN=mean)[,2])

new_parents = selectInd(c(PublicInbredYT2Phen), nInd= 37*nBIG)
old_parents = selectInd(Parents_public_update, nInd= 13*nBIG) 

Parents_public_update = c(new_parents, old_parents)