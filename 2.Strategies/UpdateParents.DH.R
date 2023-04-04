###---------
# Choosing the best lines to update the crossing blocks
###---------

if(year==(burninYears+1)){
  
  Parents_public_update = selectInd(TC2_DH, nInd= nParents_public)
  
}else{
    
  nP=nParents_public-nInd(TC2_DH)
  tmp = DH_Pub3[!(DH_Pub3@id%in%TC2_DH@id)]
  
  Parents_public_update = c(TC2_DH,selectInd(tmp, nInd= nP))
  
  }
  
  

