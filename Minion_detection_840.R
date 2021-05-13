#Minion detection task

library("dplyr")
library("clipr")

#put the trial in a single dataset
data_exp_all <- data_exp_1 %>%
  bind_rows(data_exp_2, .id = NULL) %>%
  bind_rows(data_exp_3, .id = NULL)  %>%
  bind_rows(data_exp_4, .id = NULL) 

#Group the participants by their ID 
# YOU HAVE TO CHANGE THE ID MANUALLY HERE!!!!!!!
data_ID <- data_exp_all %>%
  filter(`Participant Private ID` == "3795694")

#Select relevant column
data_clean1 <- data_ID %>%
  select("Trial Number", "Reaction Time", "Response", "Correct", "SOA", "ANSWER", "Condition", "Attempt", "Screen Name" )
#Select relevant rows
data_clean15 <- data_clean1  %>%
  filter(`Screen Name` == 'Target') %>%
  filter(ANSWER == 'Minion')

data_clean25 <- data_clean1  %>%
  filter(Attempt == 1) %>%
  filter(ANSWER == 'Minion')


#ACCURACY
Accuracy_tot<- (sum(data_clean25$Correct)/nrow(data_clean15))

data_valid<- data_clean15 %>%
  filter(Condition =="Valid")

Accuracy_valid<- (sum(data_valid$Correct)/nrow(data_valid))

data_invalid<- data_clean15 %>%
  filter(Condition =="Invalid")

Accuracy_invalid<- (sum(data_invalid$Correct)/nrow(data_invalid))

data_valid_100_acc <- data_valid %>%
  filter(SOA==100)
Accuracy_valid_100<- (sum(data_valid_100_acc$Correct)/nrow(data_valid_100_acc))

data_valid_840_acc <- data_valid %>%
  filter(SOA==840)
Accuracy_valid_840<- (sum(data_valid_840_acc$Correct)/nrow(data_valid_840_acc))

data_invalid_100_acc <- data_invalid %>%
  filter(SOA==100)
Accuracy_invalid_100<- (sum(data_invalid_100_acc$Correct)/nrow(data_invalid_100_acc))

data_invalid_840_acc <- data_invalid %>%
  filter(SOA==840)
Accuracy_invalid_840<- (sum(data_invalid_840_acc$Correct)/nrow(data_invalid_840_acc))


#CATCH
data_clean_catch <- data_clean1  %>%
  filter(`Screen Name` == 'Target') %>%
  filter(Condition =="Catch")


data_clean_catch_error <- data_clean1  %>%
  filter(Attempt == 1) %>%
  filter(`Screen Name` == 'Target')%>%
  filter(Condition =="Catch")

catch_detection_error= (100/nrow(data_clean_catch))*nrow(data_clean_catch_error)

print(catch_detection_error)

#REACTION TIME


#Select relevant rows
data_clean2 <- data_clean25  %>%
  filter(`Reaction Time` <= 1000) %>%
  filter(`Reaction Time` >= 150) 

#create a summary
summary(data_clean2$`Reaction Time`)  

#Exclude outliers
lowerq = quantile(data_clean2$`Reaction Time`)[2] 
upperq = quantile(data_clean2$`Reaction Time`)[4]
iqr = upperq - lowerq #Or use IQR(data)
extreme.threshold.upper = (iqr * 1.5) + upperq
extreme.threshold.lower = lowerq - (iqr * 1.5)

data_clean3 <- data_clean2 %>%
  filter(data_clean2$`Reaction Time` < extreme.threshold.upper & data_clean2$`Reaction Time` > extreme.threshold.lower)

RT_tot<-(mean(data_clean3$`Reaction Time`))

#Accuracy and RT valid condition 
data_valid<- data_clean3 %>%
  filter(Condition =="Valid")

data_valid <- data_valid %>%
  filter(data_valid$`Reaction Time` < extreme.threshold.upper & data_valid$`Reaction Time` > extreme.threshold.lower)


data_valid_correct<- data_valid %>%
  filter(Correct == 1)
RT_valid<-(mean(data_valid_correct$`Reaction Time`))

data_valid_100<- data_valid_correct %>%
  filter(SOA == 100)
RT_valid_100<-(mean(data_valid_100$`Reaction Time`))   

data_valid_840<- data_valid_correct %>%
  filter(SOA == 840)
RT_valid_840<-(mean(data_valid_840$`Reaction Time`)) 


#Accuracy and RT invalid condition   

data_invalid<- data_clean3 %>%
  filter(Condition =="Invalid")

data_invalid <- data_invalid %>%
  filter(data_invalid$`Reaction Time` < extreme.threshold.upper & data_invalid$`Reaction Time` > extreme.threshold.lower)



data_invalid_correct<- data_invalid %>%
  filter(Correct == 1)
RT_invalid<-(mean(data_invalid_correct$`Reaction Time`))

data_invalid_100<- data_invalid_correct %>%
  filter(SOA == 100)
RT_invalid_100<-(mean(data_invalid_100$`Reaction Time`))   

data_invalid_840<- data_invalid_correct %>%
  filter(SOA == 840)
RT_invalid_840<-(mean(data_invalid_840$`Reaction Time`))  

#Cost
Cue_effect_acc<-Accuracy_invalid-Accuracy_valid
Cue_effect_RT<-RT_invalid-RT_valid

Cue_effect_acc_100<-Accuracy_invalid_100-Accuracy_valid_100
Cue_effect_RT_100<-RT_invalid_100-RT_valid_100

Cue_effect_acc_840<-Accuracy_invalid_840-Accuracy_valid_840
Cue_effect_RT_840<-RT_invalid_840-RT_valid_840

#creating dataframe containing data
#df_1 = accuracy and RT for valid invalid, neutral plus cost and benefit
df_1 <- data.frame(Accuracy_valid = Accuracy_valid, Accuracy_invalid = Accuracy_invalid, 
                   RT_valid = RT_valid, RT_invalid = RT_invalid, Cue_effect_acc=Cue_effect_acc,  
                   Cue_effect_RT=Cue_effect_RT, catch_detection_error=catch_detection_error)

#df_2 = accuracy for SOA= 100, 840 ms
df_4 <- data.frame (Accuracy_valid_100=Accuracy_valid_100, Accuracy_valid_840=Accuracy_valid_840,
                    Accuracy_invalid_100=Accuracy_invalid_100,  Accuracy_invalid_840=Accuracy_invalid_840,
                    Cue_effect_acc_100=Cue_effect_acc_100,  Cue_effect_acc_840=Cue_effect_acc_840)

#df_5 = RT for SOA= 100, 840 ms
df_5 <- data.frame (RT_valid_100=RT_valid_100, RT_valid_840=RT_valid_840,
                    RT_invalid_100=RT_invalid_100,  RT_invalid_840=RT_invalid_840,
                    Cue_effect_RT_100=Cue_effect_RT_100, Cue_effect_RT_840=Cue_effect_RT_840)                   
write_clip(df_1) 


