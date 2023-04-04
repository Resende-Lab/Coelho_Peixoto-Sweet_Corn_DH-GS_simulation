###---------
# Choosing the best lines to update the crossing blocks
# Strategy Genomic selection Discrete
###---------


Parents_public_update = c(F5_public.sel,F3_public.sel)
Parents_public_update = selectInd(Parents_public_update, nInd= nParents_public, selectTop = TRUE, use="ebv")

