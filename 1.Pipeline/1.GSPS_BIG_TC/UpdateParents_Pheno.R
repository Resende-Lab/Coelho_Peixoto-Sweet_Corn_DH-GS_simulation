###---------
# Choosing the best lines to update the crossing blocks
# Strategy three
###---------

if(Parental == 0){
  
  Parents_public_update = selectInd(c(F7_public.sel,Parents_public_update), nInd= 50*4, selectTop = TRUE) 
  
} else if(Parental == 25){
  
  new_parents = selectInd(F7_public.sel, nInd= 13*4, selectTop = TRUE)
  old_parents = selectInd(Parents_public_update, nInd= 37*4, selectTop = TRUE) 
  
  Parents_public_update = c(new_parents, old_parents)
  
} else if(Parental == 50){
  
  new_parents = selectInd(F7_public.sel, nInd= 25*4, selectTop = TRUE)
  old_parents = selectInd(Parents_public_update, nInd= 25*4, selectTop = TRUE) 
  
  Parents_public_update = c(new_parents, old_parents)
  
} else if(Parental == 75){
  
  new_parents = selectInd(F7_public.sel, nInd= 37*4, selectTop = TRUE)
  old_parents = selectInd(Parents_public_update, nInd= 13*4, selectTop = TRUE) 
  
  Parents_public_update = c(new_parents, old_parents)
  
} else if (Parental == 100){
  
  Parents_public_update = selectInd(F7_public.sel, nInd= 50*4, selectTop = TRUE)
  
}