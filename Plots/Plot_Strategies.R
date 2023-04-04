################################################################################
##### Plotting considering different scenarios and se
################################################################################

##>>---------------------------------------------------------------
##> 1. Environment and packages
##>>---------------------------------------------------------------

require(cowplot)
require(ggplot2)
require(forcats)
require(dplyr)
require(plyr)
require(ggrepel)

###>---- Environment
rm(list=ls())

setwd(" ") # Change here for your w d


###>---- Preparing the scenarios

Scenarios = c( "Conv", "GS","DH", "DHGS","DH4y","DHGS4y","DHAlt","DHGSAlt")

Reps = c(1:50)
Var_GxE = c("GE0", "GE240")
rawData = vector("list", length = (length(Reps)*length(Scenarios)))
i = 0L
b.f = 50


###>---- Create an empty dataframe

df = data.frame(Year = character(), 
                Scenario = character(), 
                Var_GxE = character(), 
                rep = numeric(),
                hybridMean = numeric(),
                parent_mean=numeric(),
                parent_var=numeric(), 
                accF3=numeric(),
                accF5=numeric(),
                geneticGainHyb=numeric(),
                GainHyb_perCycle=numeric())


##>>---------------------------------------------------------------
##> 2. Loop through the repetitions to read te data
##>>---------------------------------------------------------------

for (Scenario in Scenarios){
  for (Rep in Reps){
    for (GxE in Var_GxE){
      
      i = i+1L
      FILE = paste0("Scenario_", Scenario,  "_r" , Rep, "_", GxE,  ".rds")
      tmp = readRDS(FILE)
      
      fl = do.call(rbind.data.frame, tmp)
      df0 = as.data.frame(t(fl), row.names = TRUE)
      
      data = data.frame(Year = -19:30, Scen = rep(Scenario, b.f),rep = rep(Rep, b.f), Var_GxE = rep(GxE, b.f),   df0)
      
      df = rbind(df, data)
      
      }
    }
  }


##>>---------------------------------------------------------------
##> 3. Organizing the dataframe
##>>---------------------------------------------------------------
df2<-df

# Organizing the names
df1$Var_GxE = sub("GE0","Absence of GE", df1$Var_GxE)
df1$Var_GxE = sub( "GE240", "Presence of GE", df1$Var_GxE)

df2 <- df1

##>>---------------------------------------------------------------
##> 4. Plotting the hybrid mean
##>>---------------------------------------------------------------

df0 = df2 %>%
  filter(Year %in% c(0,30))


#Summarize the values of reps
temp = ddply(df0,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(hybridMean),
             se = sd(hybridMean)/sqrt(length(Reps)))


# Subsetting (you can change to which scenarios do you want to plot)

dat0 = temp %>%
  filter(Scen %in% c("Conv","GS","DH","DHGS"))


# As factors
dat0$Scen <- factor(dat0$Scen, levels = c("Conv","GS","DH","DHGS"))


# Plotting
tiff("Hybrid_30.tiff", width = 16, height = 8, units = 'in', res = 300)
 ggplot(dat0,aes(x=Year,y=mean,group=Scen,color=Scen,fill=Scen,
                 linetype = Scen))+
   facet_wrap(~Var_GxE,ncol=2) +
   geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
   geom_line(size=1)+
   theme(panel.background = element_rect( fill= "gray90"),
         panel.grid.minor=element_line(colour = "white", size = 0.3, linetype="dotted"),
         panel.grid.major.y=element_line(colour = "white", size = 0.3, linetype="dotted"),
         panel.grid.major.x=element_line(colour = "white", size = 0.3, linetype="dotted"),
         plot.title = element_text(family="Roboto",size = 20, hjust = 0.5, face = "bold"),
         legend.title = element_blank(),
         legend.background  = element_blank(),
         legend.text = element_text(family="sans",size=16),
         legend.position = c(0.08,0.85),
         #legend.key = element_blank(),
         legend.key.width = unit(1.2, 'cm'),
         axis.text = element_text(family="sans",size = 16,colour = "black",face="italic"),
         axis.title = element_text(family="Roboto",size = 20),
         strip.background = element_rect( fill= "gray80"),
         strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
   scale_x_continuous("Year",limits=c(0,30))+
   scale_y_continuous("Hybrids Mean",expand=c(0,0),limits=c(200,NA), sec.axis = dup_axis(name = element_blank()))+
   scale_linetype_manual(values = c("solid", "solid", "dashed","dashed"))+
   scale_color_manual(values=(c("#4876FF","#00BA38","#4876FF","#00BA38")))
 
dev.off()


##>>---------------------------------------------------------------
##> 5. Plotting the population mean
##>>---------------------------------------------------------------

#Summarize the values of reps
temp = ddply(df2,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(parent_mean),
             se = sd(parent_mean)/sqrt(length(Reps)))

# Filterig
 dat0 = temp %>%
   filter(Scen %in% c("Conv","GS","DH","DHGS"))

# as factors
dat0$Scen <- factor(dat0$Scen, levels = c("Conv","GS","DH","DHGS"))
 

# Plotting
tiff("Pop_Mean30.tiff", width = 16, height = 8, units = 'in', res = 300)
ggplot(dat0,aes(x=Year,y=mean,group=Scen,color=Scen,fill=Scen,
                linetype = Scen))+
  facet_wrap(~Var_GxE,ncol=2) +
  geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
  geom_line(size=1)+
  theme(panel.background = element_rect( fill= "gray90"),
        panel.grid.minor=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.y=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.x=element_line(colour = "white", size = 0.3, linetype="dotted"),
        plot.title = element_text(family="Roboto",size = 20, hjust = 0.5, face = "bold"),
        legend.title = element_blank(),
        legend.background  = element_blank(),
        legend.text = element_text(family="sans",size=16),
        legend.position = c(0.08,0.85),
        legend.key.width = unit(1.2, 'cm'),
        axis.text = element_text(family="sans",size = 16,colour = "black",face="italic"),
        axis.title = element_text(family="Roboto",size = 20),
        strip.background = element_rect( fill= "gray80"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous("Year",limits=c(0,30))+
  scale_y_continuous("Parents Mean",expand=c(0,0),limits=c(95,NA), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid", "dashed","dashed"))+
  scale_color_manual(values=(c("#4876FF","#00BA38","#4876FF","#00BA38")))

dev.off()

##>>---------------------------------------------------------------
##> 5. Plotting the population variance
##>>---------------------------------------------------------------

# Summarize the values of reps
temp = ddply(df2,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(parent_var),
             se = sd(parent_var)/sqrt(length(Reps)))


# Subsetting
dat0 = temp %>%
  filter(Scen %in% c("Conv","GS","DH","DHGS"))

# as factors
dat0$Scen <- factor(dat0$Scen, levels = c("Conv","GS","DH","DHGS"))


# Plotting
tiff("PopVar-30.tiff", width = 16, height = 8, units = 'in', res = 300)
ggplot(dat0,aes(x=Year,y=mean,group=Scen,color=Scen,fill=Scen,
                linetype = Scen))+
  facet_wrap(~Var_GxE,ncol=2) +
  geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
  geom_line(size=1)+
  theme(panel.background = element_rect( fill= "gray90"),
        panel.grid.minor=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.y=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.x=element_line(colour = "white", size = 0.3, linetype="dotted"),
        plot.title = element_text(family="Roboto",size = 20, hjust = 0.5, face = "bold"),
        legend.title = element_blank(),
        legend.background  = element_blank(),
        legend.text = element_text(family="sans",size=16),
        legend.position = c(0.4,0.85),
        #legend.key = element_blank(),
        legend.key.width = unit(1.2, 'cm'),
        axis.text = element_text(family="sans",size = 16,colour = "black",face="italic"),
        axis.title = element_text(family="Roboto",size = 20),
        strip.background = element_rect( fill= "gray80"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous("Year",limits=c(0,30))+
  scale_y_continuous("Parents Variance",expand=c(0,0),limits=c(0,NA), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid", "dashed","dashed"))+
  scale_color_manual(values=(c("#4876FF","#00BA38","#4876FF","#00BA38")))

dev.off()


##>>---------------------------------------------------------------
##> 6. Plotting naive efficiency
##>>---------------------------------------------------------------

##### Subsetting

dat0 = df2 %>%
  filter(Scen %in% c("Conv","GS","DH","DHGS"))

# as factors
dat0$Scen <- factor(dat0$Scen, levels = c("Conv","GS","DH","DHGS"))

#Filtering for !burnin years
df3 = dat0  %>% 
  filter(!is.na(dat0$GainHyb_perCycle))

# Organizing the data
eff.cycle = ddply(df3,c("Year","Scen","Var_GxE"), summarize,
                  Gain = mean(GainHyb_perCycle),
                  se = sd(GainHyb_perCycle)/sqrt(length(Reps)))


#Creating new variables
eff.cycle$cycles<-NA
eff.cycle$Cyc.Num.<-NA

#as.numeric
eff.cycle$Year<-as.numeric(eff.cycle$Year)
eff.cycle$cycles<-as.numeric(eff.cycle$cycles)

#Looping
for(i in 1:nrow(eff.cycle)){
  if(eff.cycle$Scen[i]=="Conv"|eff.cycle$Scen[i]=="GS"){
    eff.cycle$cycles[i]<-5
  }else if(eff.cycle$Scen[i]=="DH"|eff.cycle$Scen[i]=="DHGS") {
    eff.cycle$cycles[i]<-3
  }else{
    eff.cycle$cycles[i]<-4
  }
}

for(i in 1:nrow(eff.cycle)){
  eff.cycle$Cyc.Num.[i]<-eff.cycle$Year[i]/eff.cycle$cycles[i]
}

eff.cycle$release<-NA

for(i in 1:nrow(eff.cycle)){
  if(eff.cycle$Year[i]==30){
    eff.cycle$release[i]<-floor(eff.cycle$Cyc.Num.[i]*2)
  }
}


#Plotting
tiff("Hybrid_Cycles-30.tiff", width = 16, height = 8, units = 'in', res = 300)
ggplot(eff.cycle,aes(x=Cyc.Num.,y=Gain,group=Scen,color=Scen,fill=Scen,linetype = Scen))+
  facet_wrap(~Var_GxE,ncol=2) +
  geom_line(size=1)+
  geom_ribbon(aes(x=Cyc.Num.,ymin=Gain-se,ymax=Gain+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
  geom_label_repel(aes(label = release), size = 4,
                   fontface = 'bold', color = "black",
                   box.padding = unit(0.35, "lines"),
                   show.legend = FALSE )+
  theme(panel.background = element_rect( fill= "gray90"),
        panel.grid.minor=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.y=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.x=element_line(colour = "white", size = 0.3, linetype="dotted"),
        plot.title = element_text(family="Roboto",size = 20, hjust = 0.5, face = "bold"),
        legend.title = element_blank(),
        legend.background  = element_blank(),
        legend.text = element_text(family="sans",size=16),
        legend.position = c(0.1,0.85),
        #legend.key = element_blank(),
        legend.key.width = unit(1.2, 'cm'),
        axis.text = element_text(family="sans",size = 16,colour = "black",face="italic"),
        axis.title = element_text(family="Roboto",size = 20),
        strip.background = element_rect( fill= "gray80"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous("Number of Cycles",limits=c(0,NA))+
  scale_y_continuous("Hybrid Gain",expand=c(0,0),limits=c(0,NA), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid", "dashed","dashed"))+
  scale_color_manual(values=c("#4876FF","#00BA38","#4876FF","#00BA38"))
dev.off()


##>>---------------------------------------------------------------
##> 7. Plotting accuracy
##>>---------------------------------------------------------------

###>>>------- Plotting Accuracy F3 (you can use the same for the plot of F5)
#subsetting
dat0 = df2 %>%
  filter(Scen %in% c("Conv","GS","DH","DHGS"))

dat0$Scen <- factor(dat0$Scen, levels = c("Conv","GS","DH","DHGS"))

#Summarize the values of reps
temp = ddply(dat0,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(accF3),
             se = sd(accF3)/sqrt(length(Reps)))

temp1=temp[which(temp$Year >= "0"),]

#Summarize the values of reps
tm = ddply(temp1,c("Scen","Var_GxE"), summarize,
           mean1 = round(mean(mean), 2))


temp$acc = NA
temp$Year = as.numeric(temp$Year)
temp$Scen = as.factor(temp$Scen)
temp$Var_GxE = as.factor(temp$Var_GxE)
temp$acc = as.numeric(temp$acc)



for (i in 1:nrow(temp)){
  for (m in 1:nrow(tm)){
    if (temp$Scen [i] == tm$Scen [m] & temp$Var_GxE [i] == tm$Var_GxE [m] ){
      if (temp$Year[i] == 30){
        temp$acc[i]=tm$mean1[m]
      }
    }
  }
}



g1=ggplot(temp,aes(x=Year,y=mean,color=Scen,linetype = Scen))+
  facet_wrap(~Var_GxE, ncol = 3) +
  geom_line(aes(color=Scen),size=1)+
  geom_line(aes(linetype=Scen))+
  geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se, fill=Scen),alpha=0.2,linetype=0, fill="grey70")+
  theme(panel.background = element_rect( fill= "gray90"),
        panel.grid.minor=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.y=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.x=element_line(colour = "white", size = 0.3, linetype="dotted"),
        plot.title = element_text(family="Roboto",size = 20, hjust = 0.5, face = "bold"),
        legend.title = element_blank(),
        legend.background  = element_blank(),
        legend.text = element_text(family="sans",size=16),
        legend.position = c(0.4,0.85),
        #legend.key = element_blank(),
        legend.key.width = unit(1.2, 'cm'),
        axis.text = element_text(family="sans",size = 16,colour = "black",face="italic"),
        axis.title = element_text(family="Roboto",size = 20),
        strip.background = element_rect( fill= "gray80"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous(limits=c(0,30))+
  scale_y_continuous("Accuracy",expand = c(0, 0), limits = c(-0.1, 0.9), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid", "dashed","dashed"))+
  scale_color_manual(values=c("#4876FF","#00BA38","#4876FF","#00BA38"))


#saving
tiff("Acc-F3.tiff", width = 16, height = 8, units = 'in', res = 300)
g1   +
  ggrepel::geom_label_repel(
    data = temp,
    mapping = aes(label = acc),
    color = 'black',
    max.iter = 3e2,
    box.padding = unit(0.35, "lines"),
    point.padding = 0.5,
    segment.color = 'grey50',
    force = 2
  )

dev.off()


##>>---------------------------------------------------------------
##> 8. Plotting hybrid mean for the other scenarios
##>>---------------------------------------------------------------
#Summarize the values of reps
temp = ddply(df2,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(hybridMean),
             se = sd(hybridMean)/sqrt(length(Reps)))

#Filtering
dat0 = temp %>%
  filter(Scen %in% c("DH4y","DHGS4y","DHAlt","DHGSAlt"))



tiff("Hybrid_oddScen.tiff", width = 16, height = 8, units = 'in', res = 300)
ggplot(dat0,aes(x=Year,y=mean,group=Scen,color=Scen,fill=Scen,
                linetype = Scen))+
  facet_wrap(~Var_GxE,ncol=2) +
  geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
  geom_line(size=1)+
  theme(panel.background = element_rect( fill= "gray90"),
        panel.grid.minor=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.y=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.x=element_line(colour = "white", size = 0.3, linetype="dotted"),
        plot.title = element_text(family="Roboto",size = 20, hjust = 0.5, face = "bold"),
        legend.title = element_blank(),
        legend.background  = element_blank(),
        legend.text = element_text(family="sans",size=16),
        legend.position = c(0.08,0.85),
        #legend.key = element_blank(),
        legend.key.width = unit(1.2, 'cm'),
        axis.text = element_text(family="sans",size = 16,colour = "black",face="italic"),
        axis.title = element_text(family="Roboto",size = 20),
        strip.background = element_rect( fill= "gray80"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous("Year",limits=c(0,30))+
  scale_y_continuous("Hybrids Mean",expand=c(0,0),limits=c(200,NA), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid", "dashed","dashed"))+
  scale_color_manual(values=(c("#4876FF","#00BA38","#4876FF","#00BA38")))

dev.off()



