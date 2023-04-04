###>>>-----------------------------------------------------------
#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data
###>>>-----------------------------------------------------------

########------------------  Year 4  --------------------########
TC3_DH = setPhenoGCA(TC2_DH,Tester3_private,reps=repTC3,p=pgy) # Fall
TC3_DH = selectInd(TC3_DH,nInd=2) # Winter

#----------
TS_pop4 = setPheno(TC3_DH,reps=2,p=pgy) # Winter
#----------

Hybrid = hybridCross(TC2_DH,Tester3_private,crossPlan = "testcross") # Fall
Hybrid = setPheno(Hybrid,reps=repTC3,p=pgy) # Winter
Hybrid = selectInd(Hybrid,nInd=2) # Winter

########------------------  Year 3  --------------------########
TC2_DH = setPhenoGCA(TC1_DH,Tester2_private,reps=repTC2,p=pgy)
TC2_DH = selectInd(TC2_DH,nInd=20) # Winter

#----------
TS_pop3 = setPheno(TC2_DH,reps=2,p=pgy) # Winter
#----------

########------------------  Year 2  --------------------########
DH_Pub2 = setEBV(DH_Pub1,gsModel)
DH_Pub3 = selectInd(DH_Pub2,nInd=800,use="ebv")

TC1_DH = setPhenoGCA(DH_Pub3,Tester1_private,reps=repTC1,p=pgy)

# Winter = Evaluate testcross 1
TC1_DH = selectInd(TC1_DH,nInd=100)

#----------
TS_pop2 = setPheno(TC1_DH,reps=2,p=pgy) # Winter
#----------

########------------------  Year 1  --------------------########
# Spring = Cross Parental Lines
F1_public = randCross(Parents_public_update, nCrosses_public, ignoreSexes = TRUE) 

# Fall and Winter = Make DH
DH_Pub1 = makeDH(F1_public, nDH = pub_DH, keepParents = FALSE) 

#----------
TS_pop1 = setPheno(DH_Pub1,reps=2,p=pgy) # Winter
#----------

#training GS model
gsModel = RRBLUP(c(TS_pop1,TS_pop2,TS_pop3,TS_pop4), use = "pheno", snpChip = 1) # Winter



