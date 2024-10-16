
    cat(" Writing records for the DH population \n")

      DHTrain1@fixEff <- as.integer(rep(paste0(year,1L),nInd(DHTrain1)))
      
      DHTrain2@fixEff <- as.integer(rep(paste0(year,2L),nInd(DHTrain2)))
      
      DHTrain3@fixEff <- as.integer(rep(paste0(year,3L),nInd(DHTrain3)))
      
      TotPop = c(DHTrain1, DHTrain2, DHTrain3)
      
      if(year %in%  c(16, 17, 18, 19)){
      trainPop <- trainPop[-c(1:265)]
      }else{
      trainPop <- trainPop[-c(1:970)] 
      }
      
      trainPop = c(trainPop, TotPop)     
   
    