###---------
# Choosing the best lines to update the crossing blocks
###---------


new_parents = selectInd(c(PublicInbredYT1Sel), nInd= 37*nBIG, selectTop = TRUE, use = "ebv")
old_parents = selectInd(Parents_public_update, nInd= 13*nBIG, selectTop = TRUE, use = "ebv") 

Parents_public_update = c(new_parents, old_parents) 

