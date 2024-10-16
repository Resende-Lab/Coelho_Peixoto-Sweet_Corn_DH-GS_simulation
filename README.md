# Description

This is a repository with the scripts from the analyses implemented for the paper: Use of simulation to optimize a sweet corn breeding
program: implementing genomic selection and doubled haploid technology (Peixoto et al. 2024). 
*DOI: https://doi.org/10.1093/g3journal/jkae128* 

## Especifications

Within both main folders, you can find a RUNME.R file. This file will call via 'source()' function all other files inside each folder. In the way that it is, you can run the repetitions for each scenario in parallel. For that, we used the HiPerGator, the University of Florida supercomputer. The code was run in R 4.1.2 and AlphaSimR 1.0.4. In addition, the folder Plot contains the script for plotting the outputs of both sets of simulations.

## Contents

**1.Pipeline folder**: This folder contains the scripts for comparing a conventional scenario with two genomic selection scenarios and the selection of the best strategy to update the parents in each cycle at a sweet corn breeding program.

Three scenarios were implemented:

i. **Conv**: Conventional breeding program (phenotypic selection).  
ii. **GSTC**: Genomic selection breeding program with the training population coming from the phenotypes of the testcrosses' parents.  
iii. **GSF1**: Genomic selection breeding program with the training population coming from the F1 population.  

All three scenarios were implemented in four distinct ways of combination of parents for the crossing block, those being 1:3, 1:1, 3:1, 0:1 (ratio of old parents to new lines) and two breeding program sizes (Small and BIG). More details in the main paper.

**2.DH_Scenarios folder**: This folder has the script for the second set of simulations, where the Conv and GSTC scenarios were compared with the implementation of DHs in the breeding program. It is worth mentioning that all scenarios of this second part of the simulations were implemented with the best strategy before being selected: 3:1 ratio. The scenarios were as follows:

i. **Conv**: Conventional breeding program.  
ii. **GSTC**: Genomic selection breeding program.   
iii. **DH**: Doubled-haploid breeding program.    
iv. **DHGS**: Doubled-haploid breeding program with genomic selection.  

***

Any questions regarding the analyses, please, contact me!

Marco


Marco Antonio Peixoto  
Email: deamorimpeixotom@ufl.edu  
Page: https://marcopxt.github.io/  
