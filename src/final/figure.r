'
The file "figure.r" creates one figure, plotting 
the effect of perception of morality on self-indulgence for consumers with two different gift-giving motivations (altruistic motivation vs. social norm motivation). 


'


rm(list=ls())

source("project_paths.r")
library(ggplot2, lib=PATH_OUT_LIBRARY_R)
library(foreign, lib=PATH_OUT_LIBRARY_R)
 
delete_outlier <- read.table(
     file=paste(PATH_OUT_DATA, "delete_outlier.txt", sep = "/"),
     header = TRUE

)

#####MEAN CENTER THE PERCEPTION OF MORALITY#####
center_appropriateness<-delete_outlier$appropriateness-mean(delete_outlier$appropriateness)

####################PLOT WITH ggplot#########
gp<-ggplot(data=delete_outlier,aes(x=center_appropriateness,y=brand_ave,colour=factor(Altruism)))
b<-gp + geom_point() + stat_smooth(method="lm")+ggtitle("INFLUENCE OF THE PERCEPTION\n OF MORALITY ON INDULGENCE")+labs(x="Perception of Morality",y="Indulgence")+theme(plot.title = element_text(face="bold", size=10))+theme(axis.title=element_text(face="bold",size=9))+theme(axis.line = element_line(size = 1,colour = "black"))+ scale_colour_discrete(name="Motivation",labels=c("Social Norm","Altruism"))

ggsave(file=paste(PATH_OUT_FIGURES, "figure1.png", sep="/"))

