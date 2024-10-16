###---------
# Choosing the best lines to update the crossing blocks
# Strategy three
###---------


new_parents = selectInd(F7_public.sel, nInd= 37)
old_parents = selectInd(Parents_public_update, nInd= 13) 

Parents_public_update = c(new_parents, old_parents)

