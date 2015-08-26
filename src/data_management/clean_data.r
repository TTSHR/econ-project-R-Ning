'
The file "clean_data.r" deletes all the data of those participants who did not finish the experiment, calculates new variables based on original data and attaches these new variables to the original data file. Also, since we would like to compare the difference between participants with altruistic motivation and participants with social norm motivation, we only focus on the data of altruism condition and social norm condition. As a result, we select the data of altruism condition and social norm condition from the original data file. IN the end, we delete the outliers according to the three-standard deviation rule and the boxplot rule.

'

source("project_paths.r")
library(foreign, lib=PATH_OUT_LIBRARY_R)

#####READ ORIGINAL DATA FILE#####
data <- read.csv(paste(PATH_IN_DATA, "gift_giving_original.csv", sep="/"),sep=";",header=T)
#data<-read.csv("data under analyzing_2.csv",sep=";",header=T)
# Initilize new variables
#####MAKE DUMMY VARIABLES:CHANGE ALL NAs IN THE INDEPENDENT VARIABLES TO 0#####
newframe<-data[,c(3,4,5)]
newframe[is.na(newframe)]<-0
data[,c(3,4,5)]<-newframe

#####DELETE ALL ROWS WHICH CONTAIN NAs (DELETE ALL THE PARTICIPANTS WHO DID NOT FINISH THE EXPERIMENT)#####
completedata<-data[complete.cases(data),]

#####CALCULATE NEW VARIABLES AND ATTACH THESE NEW VARIABLES TO THE DATA FILE#####
attach(data)
altruism_ave<-(completedata$Altruism_1+completedata$Altruism_2+completedata$Altruism_3+completedata$Altruism_4)/4
completedata<-data.frame(completedata,altruism_ave)
sn_ave<-(completedata$SN_1+completedata$SN_2+completedata$SN_3)/3
happiness<-(completedata$Happy+completedata$Cheerful+completedata$Thrilled+completedata$Excited)/4
completedata<-data.frame(completedata,sn_ave,happiness)
attach(completedata)
brand_ave<-(Polo.Ralph.Lauren+burberry+diesel+ugg+louisvuitton +clinique +godiva +armani +hugoboss +lacoste +tiffany +longchamp+jimmychoo +sevenforall +bcbg +chanel +Hennessy +Calvin.Klein +Apple +Omega+Tommy.Hilfiger)/21
completedata<-data.frame(completedata,brand_ave)
completedata[,c("Bag")]<-abs(8-completedata[,c("Bag")])
completedata[,c("Jeans")]<-abs(8-completedata[,c("Jeans")])
completedata[,c("Voucher")]<-abs(8-completedata[,c("Voucher")])
completedata[,c("Lens")]<-abs(8-completedata[,c("Lens")])
indulgence_ave<-(Bag+Jeans+Phone+Book+Video+Voucher+Lens+Card)/8
completedata<-data.frame(completedata,indulgence_ave)
colnames(completedata)[85]<-"appropriateness"

#####SELECT DATA OF ALTRUISM CONDITION AND SOCIAL NORM CONDITION#####
al_sn<-completedata[Condition==1|Condition==3,]

#####DELETE PARTICIPANTS WHOSE SCORE OF ALTRUISM_AVE ARE BEYOND 3 STANDARD DEVIATION#####
temp<-al_sn[!abs(al_sn$altruism_ave-mean(al_sn$altruism_ave)/sd(al_sn$altruism_ave))>3,]

#####ACCORDING TO THE BOXPLOT, DELETE OUTLIERS OUT OF INNER FENCES#####
boxplot(al_sn$altruism_ave~al_sn$Condition,range=1.5)
attach(al_sn)
condition1<-al_sn[Altruism==1,]
lh<-quantile(condition1$altruism_ave,probs=0.25)
uh<-quantile(condition1$altruism_ave,probs=0.75)
step<-1.5*(uh-lh)
outlier<-condition1[condition1$altruism_ave>uh+step|condition1$altruism_ave<lh-step,]
as.numeric(rownames(outlier))
as.numeric(rownames(al_sn))
delete123<-al_sn[!rownames(al_sn)%in% 123,]
delete_outlier<-delete123[!rownames(delete123)%in% 165,]
nrow(delete_outlier)
as.numeric(rownames(delete_outlier))

write.table(delete_outlier, file = paste(PATH_OUT_DATA, "delete_outlier.txt", sep="/"))

