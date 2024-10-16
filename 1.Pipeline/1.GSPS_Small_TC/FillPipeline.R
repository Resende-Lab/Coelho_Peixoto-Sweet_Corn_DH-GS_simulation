######-------------------------------------------------------------
###### Fillpipeline
######-------------------------------------------------------------

library(AlphaSimR)

###>>>>----------------- p-values for GxY effects
b.f=burninYears+futureYears

# p-values for GxY effects
Pgy = 0.5 + rnorm(b.f,0,0.03)


# p-values for GxYxE effects
Pgye1 = 0.9 + rnorm(b.f,0,0.03)
Pgye2 = 0.1 + rnorm(b.f,0,0.03)
Pgye = c(Pgye1,Pgye2)

Pgye = sample(Pgye,b.f, replace=F)

#From normal

P = runif(b.f)

###>>>------------- Running the Fillpipeline
for(year in 1:7){
  cat("FillPipeline year:",year,"of 7\n")
  
  #Year 1
  ####>>>>----Public program
  F1_public = randCross(Parents_public_update, nCrosses_public, ignoreSexes = TRUE) # Spring
  F2_public = self(F1_public, nProgeny = 10, parents = NULL, keepParents = FALSE) # Fall
  F3_public = self(F2_public, nProgeny = 6, parents = NULL, keepParents = FALSE) # Winter
  F2_public = setPheno(F2_public,reps=2) # Winter
  F2_public.sel = selectWithinFam(F2_public, nInd = 4, selectTop = TRUE) # Winter
  F3_public.s0 = F3_public[F3_public@mother%in%F2_public.sel@id] # Winter
  
  ####>>>>----Private program
  F1_private = randCross(Parents_private, nCrosses_private, ignoreSexes = TRUE)
  F2_private = self(F1_private, nProgeny = 10, parents = NULL, keepParents = FALSE)
  F2_private = setPheno(F2_private,reps=1)
  F2_private.sel = selectWithinFam(F2_private, nInd = 6, selectTop = TRUE)
  #Year 2
  if(year<7){
    pgy = Pgy[year]                                                      
    pgye = Pgye[year]
    p=P[year]
    
    ####>>>>----Public program
    F4_public = self(F3_public.s0, nProgeny = 4, parents = NULL, keepParents = FALSE) # Fall
    F3_public.s0 = setPheno(F3_public.s0,reps=1, p=pgye) # Fall
    F3_public.sel = selectWithinFam(F3_public.s0, nInd = 2, selectTop = TRUE) # Fall
    F4_public.s0 = F4_public[F4_public@mother%in%F3_public.sel@id] # Fall
    
    F5_public = self(F4_public.s0, nProgeny = 4, parents = NULL, keepParents = FALSE) # Winter
    F4_public.s0 = setPheno(F4_public.s0,reps=2, p=pgy) # Winter
    F4_public.sel = selectWithinFam(F4_public.s0, nInd = 2, selectTop = TRUE) # Winter
    F4_public.sel = selectInd(F4_public.sel, nInd = 300, selectTop = TRUE) # Winter
    F5_public.s0 = F5_public[F5_public@mother%in%F4_public.sel@id]
    
    ####>>>>----Private program
    F3_private = self(F2_private.sel, nProgeny = 8, parents = NULL, keepParents = FALSE)
    F3_private = setPheno(F3_private,reps=1, p=p)
    F3_private.sel = selectWithinFam(F3_private, nInd = 2, selectTop = TRUE)
  }
  #Year 3
  if(year<6){
    pgy = Pgy[year]                                                      
    pgye = Pgye[year]
    p=P[year]
    
    ####>>>>----Public program
    F6_public = self(F5_public.s0, nProgeny = 3, parents = NULL, keepParents = FALSE) # Fall
    F5_public.phen = setPheno(F5_public.s0,reps=1, p=pgye, varE = VarE) # Fall
    F5_public.sel = selectWithinFam(F5_public.phen, nInd = 2, selectTop = TRUE) # Fall
    F5_public.sel = selectInd(F5_public.sel, nInd = 150, selectTop = TRUE) # Fall
    F6_public.s0 = F6_public[F6_public@mother%in%F5_public.sel@id] # Fall
    TC1 = hybridCross(F5_public.sel, Tester1_private,crossPlan = "testcross") # Fall
    
    PublicHybrid_TC1 = setPheno(TC1, reps=repTC1,varE = VarE, p=pgy) # Winter
    F5_public.sel@pheno = as.matrix(calcGCA(PublicHybrid_TC1)$GCAf[,2])
    F5_public.TC = selectInd(F5_public.sel,nInd=100, selectTop = TRUE) # Winter
    F7_public = self(F6_public.s0, nProgeny = 1, parents = NULL, keepParents = FALSE) # Winter
    F6_public.sel = F6_public.s0[F6_public.s0@mother%in%F5_public.TC@id] # winter
    F6_public.sel = selectWithinFam(F6_public.sel, nInd = 1, selectTop = TRUE) # winter
    F7_public.s0 = F7_public[F7_public@mother%in%F6_public.sel@id] # winter
    
    #GS
    DHTrain1 = F5_public.sel
    
    ####>>>>----Private program
    F4_private = self(F3_private.sel, nProgeny = 6, parents = NULL, keepParents = FALSE)
    F4_private = setPheno(F4_private,reps=2, p=p)
    F4_private.sel = selectWithinFam(F4_private, nInd = 2, selectTop = TRUE)
    F4_private.sel = selectInd(F4_private.sel, nInd = length(F4_private.sel@id) * 0.2, selectTop = TRUE)
  }
  #Year 4
  if(year<5){
    pgy = Pgy[year]                                                      
    pgye = Pgye[year]
    p=P[year]
    
    ####>>>>----Public program
    F7_public.sel = F7_public.s0
    F8_public = self(F7_public.sel, nProgeny = 1, parents = NULL, keepParents = FALSE) # Fall
    TC2 = hybridCross(F7_public.sel, Tester2_private,crossPlan = "testcross") # Fall
    
    PublicHybrid_TC2 = setPheno(TC2, reps=repTC2,varE = VarE, p=pgy) # Winter
    F7_public.sel@pheno = as.matrix(calcGCA(PublicHybrid_TC2)$GCAf[,2])
    
    F9_public = self(F8_public, nProgeny = 1, parents = NULL, keepParents = FALSE) # Winter
    F7_public.TC = selectInd(F7_public.sel, nInd=15, selectTop = TRUE) # Winter
    F8_public.sel = F8_public[F8_public@mother%in%F7_public.TC@id]
    F9_public.sel = F9_public[F9_public@mother%in%F8_public.sel@id] # Winter
    
    #GS
    DHTrain2 = F7_public.sel
    DHTrain2@pheno = as.matrix(aggregate(as.matrix(calcGCA(PublicHybrid_TC2)$GCAm[,2])~as.matrix(calcGCA(PublicHybrid_TC2)$GCAm[,1]), FUN=mean)[,2])
    
    
    ####>>>>----Private program
    F5_private = self(F4_private.sel, nProgeny = 6, parents = NULL, keepParents = FALSE)
    F5_private = setPheno(F5_private,reps=2, p=p)
    F5_private.sel = selectWithinFam(F5_private, nInd = 1, selectTop = TRUE)
    F5_private.sel = selectInd(F5_private.sel, nInd = length(F5_private.sel@id) * 0.15, selectTop = TRUE)
  }
  #Year 5
  if(year<4){
    pgy = Pgy[year]                                                      
    pgye = Pgye[year]
    p=P[year]
    
    ####>>>>----Public program
    
    F10_public = self(F9_public.sel, nProgeny = 1, parents = NULL, keepParents = FALSE) # Fall
    TC3 = hybridCross(F9_public.sel, Tester3_private,crossPlan = "testcross") # Fall
    
    PublicHybrid_TC3 = setPheno(TC3, reps=repTC3,varE = VarE, p=pgy) # Winter
    F9_public.sel@pheno = as.matrix(calcGCA(PublicHybrid_TC3)$GCAf[,2])
    
    F11_public = self(F10_public, nProgeny = 1, parents = NULL, keepParents = FALSE) # Winter
    F9_public.TC = selectInd(F9_public.sel,nInd=2, selectTop = TRUE) # Winter
    F10_public.sel = F10_public[F10_public@mother%in%F9_public.TC@id]
    F11_public.sel = F11_public[F11_public@mother%in%F10_public.sel@id] # Winter
    
    #GS
    DHTrain3 = F9_public.sel
    DHTrain3@pheno = as.matrix(aggregate(as.matrix(calcGCA(PublicHybrid_TC3)$GCAm[,2])~as.matrix(calcGCA(PublicHybrid_TC3)$GCAm[,1]), FUN=mean)[,2])
    
    
    ####>>>>----Private program
    F6_private = self(F5_private.sel, nProgeny = 6, parents = NULL, keepParents = FALSE)
    F6_private = setPheno(F6_private,reps=2, p=p)
    F6_private.sel = selectWithinFam(F6_private, nInd = 1, selectTop = TRUE)
    F6_private.sel = selectInd(F6_private.sel, nInd = length(F6_private.sel@id) * 0.5, selectTop = TRUE)
  }
  #Year 6
  if(year<3){
    pgy = Pgy[year]                                                      
    pgye = Pgye[year]
    p=P[year]
    ####>>>>----Private program
    F7_private = self(F6_private.sel, nProgeny = 6, parents = NULL, keepParents = FALSE)
    F7_private = setPheno(F7_private,reps=2, p=p)
    F7_private.sel = selectWithinFam(F7_private, nInd = 1, selectTop = TRUE)
    F7_private.sel = selectInd(F7_private.sel, nInd = 15, selectTop = TRUE)
  }
  #Year 7
  if(year<2){
    pgy = Pgy[year]                                                      
    pgye = Pgye[year]
    p=P[year]
    ####>>>>----Private program
    F8_private = self(F7_private.sel, nProgeny = 6, parents = NULL, keepParents = FALSE)
    F8_private = setPheno(F8_private,reps=2, p=p)
    F8_private.sel = selectWithinFam(F8_private, nInd = 1, selectTop = TRUE)
    F8_private.sel = selectInd(F8_private.sel, nInd = 5, selectTop = TRUE)
  }
}