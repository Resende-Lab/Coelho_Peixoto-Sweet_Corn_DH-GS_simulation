###---------
# Choosing the best lines to update the crossing blocks
# Strategy three
###---------


new_parents = selectInd(F7_public.sel, nInd= 37*nBIG)
old_parents = selectInd(Parents_public_update, nInd= 13*nBIG) 

Parents_public_update = c(new_parents, old_parents)

