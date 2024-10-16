###---------
# Choosing the best lines to update the crossing blocks
# Strategy three
###---------


new_parents = selectInd(c(F5_public.sel), nInd= 37, use = "ebv")
old_parents = selectInd(Parents_public_update, nInd= 13,  use = "ebv") 

Parents_public_update = c(new_parents, old_parents)

 



