#Replace oldest hybrid parent with parent of best inbreds

Parents_public_update = c(F7_public.sel,F6_public.sel)
Parents_public_update = selectInd(Parents_public_update, nInd= nParents_public, selectTop = TRUE)

