#####-----------------------------------------------
#Track population, hybrid and parents performances
#####-----------------------------------------------

#Track performance 

#####-----------------------------------------------
#Track population, hybrid and parents performances
#####-----------------------------------------------
require(AGHmatrix)

###>>>----- Populatin
popname = Parents_public_update
genPa = genParam(popname)
M = pullSnpGeno(popname)
G.Mat = AGHmatrix::Gmatrix(M)
QT1 = pullQtlGeno(popname)
G.MatQTL = AGHmatrix::Gmatrix(QT1)

# Param.
nSNP = ncol(M)
nQTL = ncol(QT1)
LDB = NULL
LDW = NULL
ChrN = SP$nChr
QtlN = unique(SP$traits[[1]]@lociPerChr)
QTL_genos = sweep(pullQtlGeno(popname), 2,
                  SP$traits[[1]]@addEff, 
                  "*")
QTL.matrix = popVar(QTL_genos)
chr.LD.without = NULL
chr.LD = NULL 
for(c in 1:ChrN){
  i = ((c * QtlN) - QtlN) + 1
  j = c * QtlN
  LD.without <- (sum(QTL.matrix[ ,i:j]) - sum(QTL.matrix[i:j, i:j]))
  matrix.chr <- popVar(QTL_genos[ ,i:j])
  LD.chr <- (sum(matrix.chr) - sum(diag(matrix.chr)))
  chr.LD.without[c] <- list(LD.without)
  chr.LD[c] <- list(LD.chr)
}
LDB[1] = list(sum(unlist(chr.LD)) )
LDW[1] = list(sum(unlist(chr.LD.without)) )


###>>>-------- 1. Paramenters
MeanG_pop[year] = genPa$mu
MeanP_pop[year] = (meanP(popname))
Accuracy[year]  = cor(gv(popname), pheno(popname), use = "pairwise.complete.obs")
MeanA_pop[year] = mean(genPa$gv_a)
VarA_pop[year]  = genPa$varA
VarG_pop[year]  = genPa$varG
GenicVA_pop[year]  = genPa$genicVarA
GenicVG_pop[year]  = genPa$genicVarG
LDB_pop[year]  = LDB[[1]]
LDW_pop[year]  = LDW[[1]]
LDT_pop[year]  = LDB[[1]] + LDW[[1]]
covG_L_pop [year]     = genPa$covG_L
LD_pop[year]          = genPa$varG - genPa$genicVarG
covG_HW_pop[year]     = genPa$covG_HW
inbreeding[year] = mean(diag(G.Mat))-1
inbreedingQTL[year] = mean(diag(G.MatQTL))-1
HBMean[year] = meanG(HybridMean)






