# Coelho_Peixoto-Sweet_Corn_DH-GS_simulation

This is a repository with the scripts from the analyses implemented for the paper: Use of simulation to optimize a sweet corn breeding program: implementing genomic selection and doubled haploid technology (Coelho et al. 2023). *DOI:*

## Especifications

Within both main folders, you can find a RUNME.R file. This file will call via 'source()' function all other files inside each folder. In the way that it is, you can run the repetitions for each scenario in parallel. For that, we used the HiPerGator, the University of Florida supercomputer. The code was run in R 4.1.2 and AlphaSimR 1.0.4. In addition, the folder Plot contains the script for plotting the outputs of both sets of simulations.

## Contents

**1. Parental selection folder**: This folder contains the script for comparing and selecting the best strategy to update the parents in each cycle at a sweet corn breeding program, comparing an overlapping strategy with a discrete strategy.

Four scenarios were implemented:

i. **ConvOver**: Conventional breeding program (phenotypic selection) with the overlapping parental strategy.  
ii. **ConvDis**: Conventional breeding program (phenotypic selection) with the discrete parental strategy.   
iii. **GSOver**: Genomic selection breeding program with the overlapping parental strategy.  
iv. **GSDis**: Genomic selection breeding program with the discrete parental strategy.  

**2. Strategies folder**: This folder has the script for the second set of simulations. Even though eight scenarios were evaluated, we focus in the main manuscript on four of them. It is worth mentioning that all scenarios of this second part of the simulations were implemented with the best strategy before being selected: the discrete strategy. The scenarios were as follows:

i. **Conv**: Conventional breeding program.  
ii. **GS**: Genomic selection breeding program.   
iii. **DH**: Doubled-haploid breeding program.    
iv. **DHGS**: Doubled-haploid breeding program with genomic selection.  
v. **DH4y**: Doubled-haploid breeding program lasting 4 years.  
vi. **DHGS4y**: Doubled-haploid breeding program with genomic selection lasting 4 years.  
vii: **DHAlt**: Doubled-haploid breeding program alternative (400 individuals selected at year 2).  
viii: **DHGSAlt**: Doubled-haploid breeding program alternative plus genomic selection ((400 individuals selected at year 2).  

**Plots folder**: This folder contains a script to plot the graphs as an outcome of the analyses. There are two files, one for each one of the set of simulations described. You may find the plot for hybrid performance, parental performance, parental mean, accuracy of the models used, hybrid gain per cycle, and efficiency. The files are:

i. **Plot_Parental_sel**  
ii. **Plot_Strategies**  


Any questions regarding the analyses, please, contact me!

Marco


Marco Antonio Peixoto  
Email: deamorimpeixotom@ufl.edu  
Page: https://marcopxt.github.io/  
