#Advance breeding program by 1 year
#Works backwards through pipeline to avoid copying data

########--------------------  Year 3  -------------########
TC3_DH = setPhenoGCA(TC2_DH,Tester3_private,reps=repTC3,p=pgy)
TC3_DH = selectInd(TC3_DH,nInd=2)

Hybrid = hybridCross(TC2_DH,Tester3_private,crossPlan = "testcross")
Hybrid = setPheno(Hybrid,reps=repTC3,p=pgy)
Hybrid = selectInd(Hybrid,nInd=2)


########-------------------  Year 2  ---------------########
DH_Pub2 = setPheno(DH_Pub1,reps=2,p=pgye)
DH_Pub3 = selectInd(DH_Pub2,nInd=200)

TC2_DH = setPhenoGCA(DH_Pub3,Tester2_private,reps=repTC2,p=pgy)
TC2_DH = selectInd(TC2_DH,nInd=30)


########-----------------  Year 1 ------------------ ########
F1_public = randCross(Parents_public_update, nCrosses_public, ignoreSexes = TRUE)
# Fall and Winter = Make DH
DH_Pub1 = makeDH(F1_public, nDH = pub_DH, keepParents = FALSE) 

