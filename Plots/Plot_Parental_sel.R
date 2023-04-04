################################################################################
##### Plotting considering different scenarios and se
################################################################################
require(plyr)
require(ggplot2)
require(AlphaSimR)
library(RColorBrewer)

####>>>>------------ Environment
rm(list=ls())

setwd("/orange/mresende/marcopxt/DH/1.Pipeline/30")


####>>>>------------ Preparing the scenarios

Scenarios = c("BSc","BSd10","BSd","GSd10","GSc","GSd")

Reps = c(1:49)
Var_GxE = c("GE0", "GE240")
rawData = vector("list", length = (length(Reps)*length(Scenarios)))
i = 0L
b.f = 50


####>>>>------------ Creat an empty dataframe

df = data.frame(Year = character(),
                Scenario = character(),
                Var_GxE = character(),
                rep = numeric(),
                hybridMean = numeric(),
                accF3=numeric(),
                accF5=numeric(),
                parent_mean=numeric(),
                parent_var=numeric())



####>>>>------------ Fullfil the dataframe

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

##################################################################
######### Duplicating the df file to be used after again ##########
##################################################################
df2<-df

#################################
####### Hybrids Parameters ######
#################################

df2$Var_GxE = sub("GE0","Absence of GE", df2$Var_GxE)
df2$Var_GxE = sub( "GE240", "Presence of GE", df2$Var_GxE)


df2$Scen = sub("BSd10","out", df2$Scen)
df2$Scen = sub( "GSd10", "out", df2$Scen)
df2$Scen = sub("BSc","OVER_Conv", df2$Scen)
df2$Scen = sub( "GSc", "OVER_GS", df2$Scen)
df2$Scen = sub("BSd","DISC_Conv", df2$Scen)
df2$Scen = sub( "GSd", "DISC_GS", df2$Scen)

df3<-df2

#---------------------------------------------------------------
###~~~~~~~ Hybrid Mean ~~~~~~~###
#---------------------------------------------------------------

#Summarize the values of reps
temp = ddply(df3,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(hybridMean),
             se = sd(hybridMean)/sqrt(length(Reps)))

temp1 = temp %>%
  filter(., Year > -1)

temp2 = temp1 %>%
  filter(., Scen != "out")


### Plot 1 Hybrid mean
tiff("Hybrid_30.tiff", width = 16, height = 8, units = 'in', res = 300)
ggplot(temp2,aes(x=Year,y=mean,group=Scen,color=Scen,fill=Scen,
                linetype = Scen))+
  facet_wrap(~Var_GxE,ncol=2) +
  geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
  geom_line(size=1)+
  theme(panel.background = element_rect( fill= "gray90"),#color="black", size=0.75, linetype="solid"),
        panel.grid.minor=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.y=element_line(colour = "white", size = 0.3, linetype="dotted"),
        panel.grid.major.x=element_line(colour = "white", size = 0.3, linetype="dotted"),
        plot.title = element_text(family="Roboto",size = 20, hjust = 0.5, face = "bold"),
        legend.title = element_blank(),
        legend.background  = element_blank(),#element_rect(fill= "gray90"), #,color="black", size=0.5, linetype="solid"),
        legend.text = element_text(family="sans",size=16),
        legend.position = c(0.1,0.8),
        #legend.key = element_blank(),
        legend.key.width = unit(1.2, 'cm'),
        axis.text = element_text(family="sans",size = 16,colour = "black",face="italic"),
        axis.title = element_text(family="Roboto",size = 20),
        strip.background = element_rect( fill= "gray80"),#color="black",size=0.75, linetype="solid"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous("Year",limits=c(0,30))+
  scale_y_continuous("Hybrids Mean",expand=c(0,0),limits=c(200,NA), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid",  "dashed","dashed"))+
  scale_color_manual(values=c("#F8766D","#4876FF","#F8766D","#4876FF"))
dev.off()

#---------------------------------------------------------------
###~~~~~~~ Parent Mean ~~~~~~~###
#---------------------------------------------------------------

#Summarize the values of reps
temp = ddply(df3,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(parent_mean),
             se = sd(parent_mean)/sqrt(length(Reps)))

temp1 = temp %>%
  filter(., Year > -1)

temp2 = temp1 %>%
  filter(., Scen != "out")

###>>>----------- Plotting PopMean
tiff("ParentM_30.tiff", width = 16, height = 8, units = 'in', res = 300)
ggplot(temp2,aes(x=Year,y=mean,group=Scen,color=Scen,fill=Scen,
                linetype = Scen))+
  facet_wrap(~Var_GxE,ncol=2) +
  geom_line(size=1)+
  geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
  theme(panel.background = element_rect( fill= "gray90"),#color="black", size=0.75, linetype="solid"),
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
        strip.background = element_rect( fill= "gray80"),#color="black",size=0.75, linetype="solid"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous("Year",limits=c(0,30))+
  scale_y_continuous("Parents Mean",expand=c(0,0),limits=c(100,NA), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid",  "dashed","dashed"))+
  scale_color_manual(values=c("#F8766D","#4876FF","#F8766D","#4876FF"))
dev.off()

#---------------------------------------------------------------
###~~~~~~~ Parent variance ~~~~~~~###
#---------------------------------------------------------------

#Summarize the values of reps
temp = ddply(df3,c("Year","Scen","Var_GxE"), summarize,
             mean = mean(parent_var),
             se = sd(parent_var)/sqrt(length(Reps)))



temp1 = temp %>%
  filter(., Year > -1)

temp2 = temp1 %>%
  filter(., Scen != "out")


###>>>----------- Plotting PopMean
tiff("ParentV_30.tiff", width = 16, height = 8, units = 'in', res = 300)
ggplot(temp2,aes(x=Year,y=mean,group=Scen,color=Scen,fill=Scen,
                linetype = Scen))+
  facet_wrap(~Var_GxE,ncol=2) +
  geom_line(size=1)+
  geom_ribbon(aes(x=Year,ymin=mean-se,ymax=mean+se),alpha=0.2,linetype=0,show.legend = F, fill="grey70")+
  theme(panel.background = element_rect( fill= "gray90"),#color="black", size=0.75, linetype="solid"),
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
        strip.background = element_rect( fill= "gray80"),#color="black",size=0.75, linetype="solid"),
        strip.text = element_text(family="Playfair", size = 20, colour = 'black',face="italic"))+
  scale_x_continuous("Year",limits=c(0,30))+
  scale_y_continuous("Parents Variance",expand=c(0,0),limits=c(0,NA), sec.axis = dup_axis(name = element_blank()))+
  scale_linetype_manual(values = c("solid", "solid",  "dashed","dashed"))+
  scale_color_manual(values=c("#F8766D","#4876FF","#F8766D","#4876FF"))
dev.off()








