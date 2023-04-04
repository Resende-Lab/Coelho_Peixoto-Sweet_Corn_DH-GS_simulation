# Coelho_Peixoto-Sweet_Corn_DH-GS_simulation

This is a repository with the scripts of the paper: Use of simulation to optimize a sweet corn breeding program: implementing genomic selection and doubled haploid technology (Coelho et al. 2023). *DOI:*

### Especifications

Within both main folders you can find a RUNME.R file. This file will call via 'source()' function all other files inside each folder. In the way that it is, you can run the repetitions for each scenario in parallel. For that, we used the HiPerGator, the University of Florida supercomputer. The code was run in R 4.1.2 and AlphaSimR 1.0.4. In addition, the folder Plot contains the script for plotting the outputs of both set of simulations.

### Contents

**1. Parental selection folder**: This folder contains the script for comparing and select best strategy to update the parents in each cycle at a sweet corn breeding program, comparing an overlapping strategy with a discrete strategy.

Four scenarios were implemented:

i. **ConvOver**: Conventional breeding program (phenotypic selection) with the overlapping parental strategy.  
ii. **ConvDis**: Conventional breeding program (phenotypic selection) with the discrete parental strategy.   
iii. **GSOver**: Genomic selection breeding program with the overlapping parental strategy.  
iv. **GSDis**: Genomic selection breeding program with the discrete parental strategy.  

**2. Startegies folder**: This folder has the script for the second set of simulations. Even though eigth scenarios were evaluated, we focus in the main manuscript on four of them. It is worth mentioning that all scenarios of this second part of simulations were implemented with the best strategy before selected: the discrete strategy. The scenarios were as follow:

i. **conv**: Conventional breeding program.
ii. **CONVe_HTP**: conventional breeding program with high-throughput phenotyping.   
iii. **GSe**: conventional breeding program with genomic selection.   
iv. **GSe_HTP**: conventional breeding program with genomic selection and high-throughput phenotyping.   

**Plot folder**: This folder contains a script to plot the graphs as an outcome of the analyses.

Any question about the analyses, please, contact me!

Marco


M.Sc. Marco Antonio Peixoto  
Email: deamorimpeixotom@ufl.edu  
Page: https://marcopxt.github.io/  
