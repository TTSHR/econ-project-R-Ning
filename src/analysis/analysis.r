'
The file "analysis.r" firstly checks whether the manipulations manipulate altruistic motivation vs. obeying social norm motivation in our experiment.
Secondly, this file computes the interactive effect of consumers gift-giving motivations and their perception of whether indulgence is moral or immoral on consumers self-indulgence.
Finally, we test the mediating role of happiness in the relatonship between gift-giving motivations and self-indulgence.

'

rm(list=ls())
options(digits=3)


source("project_paths.r")
library(foreign, lib=PATH_OUT_LIBRARY_R)
library(mediation, lib=PATH_OUT_LIBRARY_R)
library(sandwich, lib=PATH_OUT_LIBRARY_R)

delete_outlier <- read.table(
     file=paste(PATH_OUT_DATA, "delete_outlier.txt", sep = "/"),
     header = TRUE
)

sink(paste(PATH_OUT_ANALYSIS,"analysis_results.txt",sep="/"))
####################MANIPULATION CHECK############################
#####CHECK THE MANIPULATION OF ALTRUISTIC MOTIVATION#####
altruism_check<-aov(altruism_ave~Condition,data=delete_outlier)
summary(altruism_check)
print(model.tables(altruism_check,"means"),digits=3)

#####CHECK THE MANIPULATION OF SOCIAL NORM MOTIVATION#####
sn_check<-aov(sn_ave~Condition,data=delete_outlier)
summary(sn_check)
print(model.tables(sn_check,"means"),digits=3)

#################REGRESSION##################
center_appropriateness<-delete_outlier$appropriateness-mean(delete_outlier$appropriateness)
delete_outlier<-data.frame(delete_outlier,center_appropriateness)
#####CHECK THE INTERACTION EFFECT OF GIFT-GIVING MOTIVATION AND PERCEPTION OF MORALITY ON SELF-INDULGENCE#####
inter_effect<-lm(brand_ave~Altruism*center_appropriateness,data=delete_outlier)
summary(inter_effect)
inter_effect$coefficients
#####CHECK THE INFLUENCE OF PERCEPTION OF MORALITY ON SELF-INDULGENCE FOR PARTICIPANTS WITH AN ALTRUISTIC MOTIVATION#####
delete_outlier_al<-delete_outlier[delete_outlier$Condition==1,]
rate_al<-lm(brand_ave~center_appropriateness,data=delete_outlier_al)
summary(rate_al)
rate_al$coefficients
#####CHECK THE INFLUENCE OF PERCEPTION OF MORALILTY ON SELF-INDULGENCE FOR PARTICIPANTS WITH A SOCIAL NORM MOTIVATION#####
delete_outlier_sn<-delete_outlier[delete_outlier$Condition==3,]
rate_sn<-lm(brand_ave~center_appropriateness,data=delete_outlier_sn)
summary(rate_sn)


#########MEDIATION, CHECK WHETHER HAPPINESS IS THE POTETIAL MEDIATOR#############
model.m<-lm(happiness~Altruism,data=delete_outlier)
model.y<-lm(brand_ave~Altruism+happiness,data=delete_outlier)
m<-mediate(model.m,model.y,sims=10000,treat="Altruism",mediator="happiness")
summary(m)
sink()



