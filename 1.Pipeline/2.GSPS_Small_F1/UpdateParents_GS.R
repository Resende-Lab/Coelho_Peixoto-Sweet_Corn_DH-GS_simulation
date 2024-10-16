###---------
# Choosing the best lines to update the crossing blocks
# Strategy three
###---------




if(Parental == 0){

  Parents_public_update = selectInd(c(F5_public.sel,Parents_public_update), nInd= 50, selectTop = TRUE, use = "ebv") 
  
  
}else if(Parental == 25){
  
  new_parents = selectInd(c(F5_public.sel), nInd= 13, selectTop = TRUE, use = "ebv")
  old_parents = selectInd(Parents_public_update, nInd= 37, selectTop = TRUE, use = "ebv") 
  
  Parents_public_update = c(new_parents, old_parents)
  
}else if(Parental == 50){
  
  new_parents = selectInd(c(F5_public.sel), nInd= 25, selectTop = TRUE, use = "ebv")
  old_parents = selectInd(Parents_public_update, nInd= 25, selectTop = TRUE, use = "ebv") 
  
  Parents_public_update = c(new_parents, old_parents)
  
}else if(Parental == 75){
  
  new_parents = selectInd(c(F5_public.sel), nInd= 37, selectTop = TRUE, use = "ebv")
  old_parents = selectInd(Parents_public_update, nInd= 13, selectTop = TRUE, use = "ebv") 
  
  Parents_public_update = c(new_parents, old_parents)
  
}else {
  
  new_parents = selectInd(c(F5_public.sel), nInd= 50, selectTop = TRUE, use = "ebv")
  
  Parents_public_update = new_parents
  
}




