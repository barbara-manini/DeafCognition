library("dplyr")
library("writexl")
library("csv")
library("clipr")
#put the trial in a single dataset
data_exp <- data_exp_1 %>%
  bind_rows(data_exp_2, .id = NULL) %>%
  bind_rows(data_exp_3, .id = NULL) 

#Select relevant column
 data_clean1 <- data_exp %>%
  select("Trial Number", "Reaction Time", "Response", "Correct", "SOA", "ANSWER", "Condition", "Attempt" )
#Select relevant rows
 data_clean2 <- data_clean1  %>%
  filter(Attempt == 1)
#create a summary
 summary(data_clean2$`Reaction Time`)         

#Exclude outliers
  lowerq = quantile(data_clean2$`Reaction Time`)[1] 
  upperq = quantile(data_clean2$`Reaction Time`)[3]
  iqr = upperq - lowerq #Or use IQR(data)
  extreme.threshold.upper = (iqr * 1.5) + upperq
  extreme.threshold.lower = lowerq - (iqr * 1.5)
  
  data_clean3 <- data_clean2 %>%
    filter(data_clean2$`Reaction Time` < extreme.threshold.upper & data_clean2$`Reaction Time` > extreme.threshold.lower)


  Accuracy_tot<- (sum(data_clean3$Correct)/nrow(data_clean3))
  RT_tot<-(mean(data_clean3$`Reaction Time`))
  
 #Accuracy and RT valid condition 
  data_valid<- data_clean3 %>%
    filter(Condition =="Valid")
  Accuracy_valid<- (sum(data_valid$Correct)/nrow(data_valid))
  
 data_valid_50_acc <- data_valid %>%
   filter(SOA==50)
 Accuracy_valid_50<- (sum(data_valid_50_acc$Correct)/nrow(data_valid_50_acc))
  
 data_valid_150_acc <- data_valid %>%
   filter(SOA==150)
 Accuracy_valid_150<- (sum(data_valid_150_acc$Correct)/nrow(data_valid_150_acc))
 
 data_valid_350_acc <- data_valid %>%
   filter(SOA==350)
 Accuracy_valid_350<- (sum(data_valid_350_acc$Correct)/nrow(data_valid_350_acc))
 
 data_valid_600_acc <- data_valid %>%
   filter(SOA==600)
 Accuracy_valid_600<- (sum(data_valid_600_acc$Correct)/nrow(data_valid_600_acc))
 
 data_valid_1000_acc <- data_valid %>%
   filter(SOA==1000)
 Accuracy_valid_1000<- (sum(data_valid_1000_acc$Correct)/nrow(data_valid_1000_acc))
 
 data_valid_long_SOA_acc <- data_valid %>%
   filter(SOA==600 | SOA==1000)
 Accuracy_valid_long_SOA<- (sum(data_valid_long_SOA_acc$Correct)/nrow(data_valid_long_SOA_acc))
 
 data_valid_short_SOA<- data_valid %>%
   filter(SOA==50 | SOA==150)
 Accuracy_valid_short_SOA<- (sum(data_valid_short_SOA$Correct)/nrow(data_valid_short_SOA)) 
 
  data_valid_correct<- data_valid %>%
    filter(Correct == 1)
    RT_valid<-(mean(data_valid_correct$`Reaction Time`))
    
    data_valid_50<- data_valid_correct %>%
      filter(SOA == 50)
    RT_valid_50<-(mean(data_valid_50$`Reaction Time`))   

    data_valid_150<- data_valid_correct %>%
      filter(SOA == 150)
    RT_valid_150<-(mean(data_valid_150$`Reaction Time`))   
    
    data_valid_350<- data_valid_correct %>%
      filter(SOA == 350)
    RT_valid_350<-(mean(data_valid_350$`Reaction Time`))     
    
    data_valid_600<- data_valid_correct %>%
      filter(SOA == 600)
    RT_valid_600<-(mean(data_valid_600$`Reaction Time`))   
    
    data_valid_1000<- data_valid_correct %>%
      filter(SOA == 1000)
    RT_valid_1000<-(mean(data_valid_1000$`Reaction Time`))   
    
    data_valid_long_SOA<- data_valid_correct %>%
      filter(SOA == 600 | SOA == 1000 )
    RT_valid_long_SOA<-(mean( data_valid_long_SOA$`Reaction Time`))      
    
    data_valid_short_SOA<- data_valid_correct %>%
      filter(SOA == 50 | SOA == 150 )
    RT_valid_short_SOA<-(mean( data_valid_short_SOA$`Reaction Time`))     
    
    #Accuracy and RT invalid condition   
    
  data_invalid<- data_clean3 %>%
    filter(Condition =="Invalid")
  Accuracy_invalid<- (sum(data_invalid$Correct)/nrow(data_invalid))
  
  data_invalid_50_acc <- data_invalid %>%
    filter(SOA==50)
  Accuracy_invalid_50<- (sum(data_invalid_50_acc$Correct)/nrow(data_invalid_50_acc))
  
  data_invalid_150_acc <- data_invalid %>%
    filter(SOA==150)
  Accuracy_invalid_150<- (sum(data_invalid_150_acc$Correct)/nrow(data_invalid_150_acc))
  
  data_invalid_350_acc <- data_invalid %>%
    filter(SOA==350)
  Accuracy_invalid_350<- (sum(data_invalid_350_acc$Correct)/nrow(data_invalid_350_acc))
  
  data_invalid_600_acc <- data_invalid %>%
    filter(SOA==600)
  Accuracy_invalid_600<- (sum(data_invalid_600_acc$Correct)/nrow(data_invalid_600_acc))
  
  data_invalid_1000_acc <- data_invalid %>%
    filter(SOA==1000)
  Accuracy_invalid_1000<- (sum(data_invalid_1000_acc$Correct)/nrow(data_invalid_1000_acc))
  
  data_invalid_long_SOA_acc <- data_invalid %>%
    filter(SOA==600 | SOA==1000)
  Accuracy_invalid_long_SOA<- (sum(data_invalid_long_SOA_acc$Correct)/nrow(data_invalid_long_SOA_acc))
  
  data_invalid_short_SOA<- data_invalid %>%
    filter(SOA==50 | SOA==150)
  Accuracy_invalid_short_SOA<- (sum(data_invalid_short_SOA$Correct)/nrow(data_invalid_short_SOA)) 
  
  data_invalid_correct<- data_invalid %>%
    filter(Correct == 1)
  RT_invalid<-(mean(data_invalid_correct$`Reaction Time`))
  
  data_invalid_50<- data_invalid_correct %>%
    filter(SOA == 50)
  RT_invalid_50<-(mean(data_invalid_50$`Reaction Time`))   
  
  data_invalid_150<- data_invalid_correct %>%
    filter(SOA == 150)
  RT_invalid_150<-(mean(data_invalid_150$`Reaction Time`))   
  
  data_invalid_350<- data_invalid_correct %>%
    filter(SOA == 350)
  RT_invalid_350<-(mean(data_invalid_350$`Reaction Time`))     
  
  data_invalid_600<- data_invalid_correct %>%
    filter(SOA == 600)
  RT_invalid_600<-(mean(data_invalid_600$`Reaction Time`))   
  
  data_invalid_1000<- data_invalid_correct %>%
    filter(SOA == 1000)
  RT_invalid_1000<-(mean(data_invalid_1000$`Reaction Time`))   
  
  data_invalid_long_SOA<- data_invalid_correct %>%
    filter(SOA == 600 | SOA == 1000 )
  RT_invalid_long_SOA<-(mean( data_invalid_long_SOA$`Reaction Time`))      
  
  data_invalid_short_SOA<- data_invalid_correct %>%
    filter(SOA == 50 | SOA == 150 )
  RT_invalid_short_SOA<-(mean( data_invalid_short_SOA$`Reaction Time`))     
  
  #Accuracy and RT neutral condition  
  
  data_neutral<- data_clean3 %>%
    filter(Condition =="Neutral")
  Accuracy_neutral<- (sum(data_neutral$Correct)/nrow(data_neutral))
  
  data_neutral_50_acc <- data_neutral %>%
    filter(SOA==50)
  Accuracy_neutral_50<- (sum(data_neutral_50_acc$Correct)/nrow(data_neutral_50_acc))
  
  data_neutral_150_acc <- data_neutral %>%
    filter(SOA==150)
  Accuracy_neutral_150<- (sum(data_neutral_150_acc$Correct)/nrow(data_neutral_150_acc))
  
  data_neutral_350_acc <- data_neutral %>%
    filter(SOA==350)
  Accuracy_neutral_350<- (sum(data_neutral_350_acc$Correct)/nrow(data_neutral_350_acc))
  
  data_neutral_600_acc <- data_neutral %>%
    filter(SOA==600)
  Accuracy_neutral_600<- (sum(data_neutral_600_acc$Correct)/nrow(data_neutral_600_acc))
  
  data_neutral_1000_acc <- data_neutral %>%
    filter(SOA==1000)
  Accuracy_neutral_1000<- (sum(data_neutral_1000_acc$Correct)/nrow(data_neutral_1000_acc))
  
  data_neutral_long_SOA_acc <- data_neutral %>%
    filter(SOA==600 | SOA==1000)
  Accuracy_neutral_long_SOA<- (sum(data_neutral_long_SOA_acc$Correct)/nrow(data_neutral_long_SOA_acc))
  
  data_neutral_short_SOA<- data_neutral %>%
    filter(SOA==50 | SOA==150)
  Accuracy_neutral_short_SOA<- (sum(data_neutral_short_SOA$Correct)/nrow(data_neutral_short_SOA)) 
  
  data_neutral_correct<- data_neutral %>%
    filter(Correct == 1)
  RT_neutral<-(mean(data_neutral_correct$`Reaction Time`))
  
  data_neutral_50<- data_neutral_correct %>%
    filter(SOA == 50)
  RT_neutral_50<-(mean(data_neutral_50$`Reaction Time`))   
  
  data_neutral_150<- data_neutral_correct %>%
    filter(SOA == 150)
  RT_neutral_150<-(mean(data_neutral_150$`Reaction Time`))   
  
  data_neutral_350<- data_neutral_correct %>%
    filter(SOA == 350)
  RT_neutral_350<-(mean(data_neutral_350$`Reaction Time`))     
  
  data_neutral_600<- data_neutral_correct %>%
    filter(SOA == 600)
  RT_neutral_600<-(mean(data_neutral_600$`Reaction Time`))   
  
  data_neutral_1000<- data_neutral_correct %>%
    filter(SOA == 1000)
  RT_neutral_1000<-(mean(data_neutral_1000$`Reaction Time`))   
  
  data_neutral_long_SOA<- data_neutral_correct %>%
    filter(SOA == 600 | SOA == 1000 )
  RT_neutral_long_SOA<-(mean( data_neutral_long_SOA$`Reaction Time`))      
  
  data_neutral_short_SOA<- data_neutral_correct %>%
    filter(SOA == 50 | SOA == 150 )
  RT_neutral_short_SOA<-(mean( data_neutral_short_SOA$`Reaction Time`)) 
  
  #Benefit
  
  Benefit_acc<-Accuracy_valid-Accuracy_neutral
  Benefit_RT<-RT_valid-RT_neutral
  
  Benefit_acc_50<-Accuracy_valid_50-Accuracy_neutral_50
  Benefit_RT_50<-RT_valid_50-RT_neutral_50
  
  Benefit_acc_150<-Accuracy_valid_150-Accuracy_neutral_150
  Benefit_RT_150<-RT_valid_150-RT_neutral_150 
  
  Benefit_acc_350<-Accuracy_valid_350-Accuracy_neutral_350
  Benefit_RT_350<-RT_valid_350-RT_neutral_350 
  
  Benefit_acc_600<-Accuracy_valid_600-Accuracy_neutral_600
  Benefit_RT_600<-RT_valid_600-RT_neutral_600
  
  Benefit_acc_1000<-Accuracy_valid_1000-Accuracy_neutral_1000
  Benefit_RT_1000<-RT_valid_1000-RT_neutral_1000
  
  Benefit_acc_long_SOA<-Accuracy_valid_long_SOA-Accuracy_neutral_long_SOA
  Benefit_RT_long_SOA<-RT_valid_long_SOA-RT_neutral_long_SOA
  
  Benefit_acc_short_SOA<-Accuracy_valid_short_SOA-Accuracy_neutral_short_SOA
  Benefit_RT_short_SOA<-RT_valid_short_SOA-RT_neutral_short_SOA
  
  
  #Cost
  Cost_acc<-Accuracy_invalid-Accuracy_neutral
  Cost_RT<-RT_invalid-RT_neutral
  
  Cost_acc_50<-Accuracy_invalid_50-Accuracy_neutral_50
  Cost_RT_50<-RT_invalid_50-RT_neutral_50
  
  Cost_acc_150<-Accuracy_invalid_150-Accuracy_neutral_150
  Cost_RT_150<-RT_invalid_150-RT_neutral_150 
  
  Cost_acc_350<-Accuracy_invalid_350-Accuracy_neutral_350
  Cost_RT_350<-RT_invalid_350-RT_neutral_350 
  
  Cost_acc_600<-Accuracy_invalid_600-Accuracy_neutral_600
  Cost_RT_600<-RT_invalid_600-RT_neutral_600
  
  Cost_acc_1000<-Accuracy_invalid_1000-Accuracy_neutral_1000
  Cost_RT_1000<-RT_invalid_1000-RT_neutral_1000
  
  Cost_acc_long_SOA<-Accuracy_invalid_long_SOA-Accuracy_neutral_long_SOA
  Cost_RT_long_SOA<-RT_invalid_long_SOA-RT_neutral_long_SOA
  
  Cost_acc_short_SOA<-Accuracy_invalid_short_SOA-Accuracy_neutral_short_SOA
  Cost_RT_short_SOA<-RT_invalid_short_SOA-RT_neutral_short_SOA
  
  #creating dataframe containing data
  #df_1 = accuracy and RT for valid invalid, neutral plus cost and benefit
  df_1 <- data.frame(Accuracy_valid = Accuracy_valid, Accuracy_invalid = Accuracy_invalid, Accuracy_neutral = Accuracy_neutral,
                     RT_valid = RT_valid, RT_invalid = RT_invalid, RT_neutral= RT_neutral, Benefit_acc=Benefit_acc, Cost_acc= Cost_acc, Benefit_RT=Benefit_RT, Cost_RT=Cost_RT)
  
  
  #df_2 = accuracy for short long and 350 SOA
  df_2 <- data.frame (Accuracy_valid_long_SOA = Accuracy_valid_long_SOA, Accuracy_valid_short_SOA = Accuracy_valid_short_SOA, Accuracy_valid_350 = Accuracy_valid_350, 
                      Accuracy_invalid_long_SOA = Accuracy_invalid_long_SOA, Accuracy_invalid_short_SOA = Accuracy_invalid_short_SOA, Accuracy_invalid_350 = Accuracy_invalid_350, 
                      Accuracy_neutral_long_SOA=Accuracy_neutral_long_SOA, Accuracy_neutral_short_SOA=Accuracy_neutral_short_SOA, Accuracy_neutral_350=Accuracy_neutral_350, 
                       Benefit_acc_long_SOA=Benefit_acc_long_SOA, Benefit_acc_short_SOA=Benefit_acc_short_SOA, Benefit_acc_350=Benefit_acc_350, 
                      Cost_acc_long_SOA=Cost_acc_long_SOA, Cost_acc_short_SOA=Cost_acc_short_SOA, Cost_acc_350=Cost_acc_350 )
 
   #df_3 = RT for short long and 350 SOA                  
  df_3 <- data.frame (RT_valid_long_SOA = RT_valid_long_SOA, RT_valid_short_SOA = RT_valid_short_SOA, RT_valid_350 = RT_valid_350, 
                      RT_invalid_long_SOA = RT_invalid_long_SOA, RT_invalid_short_SOA = RT_invalid_short_SOA, RT_invalid_350 = RT_invalid_350, 
                      RT_neutral_long_SOA=RT_neutral_long_SOA, RT_neutral_short_SOA=RT_neutral_short_SOA, RT_neutral_350=RT_neutral_350, 
                      Benefit_RT_long_SOA=Benefit_RT_long_SOA, Benefit_RT_short_SOA=Benefit_RT_short_SOA, Benefit_RT_350=Benefit_RT_350, 
                      Cost_RT_long_SOA=Cost_RT_long_SOA, Cost_RT_short_SOA=Cost_RT_short_SOA, Cost_RT_350=Cost_RT_350 ) 
  
  #df_4 = accuracy for SOA= 50, 150, 350, 600, 1000 ms
  df_4 <- data.frame (Accuracy_valid_50=Accuracy_valid_50, Accuracy_valid_150=Accuracy_valid_150, Accuracy_valid_350=Accuracy_valid_350, Accuracy_valid_600=Accuracy_valid_600, Accuracy_valid_1000=Accuracy_valid_1000,
                      Accuracy_invalid_50=Accuracy_invalid_50, Accuracy_invalid_150=Accuracy_invalid_150, Accuracy_invalid_350=Accuracy_invalid_350, Accuracy_invalid_600=Accuracy_invalid_600, Accuracy_invalid_1000=Accuracy_invalid_1000,
                      Accuracy_neutral_50=Accuracy_neutral_50, Accuracy_neutral_150=Accuracy_neutral_150, Accuracy_neutral_350=Accuracy_neutral_350, Accuracy_neutral_600=Accuracy_neutral_600, Accuracy_neutral_1000=Accuracy_neutral_1000,
                      Benefit_acc_50=Benefit_acc_50, Benefit_acc_150=Benefit_acc_150, Benefit_acc_350=Benefit_acc_350, Benefit_acc_600=Benefit_acc_600, Benefit_acc_1000=Benefit_acc_1000,
                      Cost_acc_50=Cost_acc_50, Cost_acc_150=Cost_acc_150, Cost_acc_350=Cost_acc_350, Cost_acc_600=Cost_acc_600, Cost_acc_1000=Cost_acc_1000)
  
  #df_5 = RT for SOA= 50, 150, 350, 600, 1000 ms
  df_5 <- data.frame (RT_valid_50=RT_valid_50, RT_valid_150=RT_valid_150, RT_valid_350=RT_valid_350, RT_valid_600=RT_valid_600, RT_valid_1000=RT_valid_1000,
                      RT_invalid_50=RT_invalid_50, RT_invalid_150=RT_invalid_150, RT_invalid_350=RT_invalid_350, RT_invalid_600=RT_invalid_600, RT_invalid_1000=RT_invalid_1000,
                      RT_neutral_50=RT_neutral_50, RT_neutral_150=RT_neutral_150, RT_neutral_350=RT_neutral_350, RT_neutral_600=RT_neutral_600, RT_neutral_1000=RT_neutral_1000,
                      Benefit_RT_50=Benefit_RT_50, Benefit_RT_150=Benefit_RT_150, Benefit_RT_350=Benefit_RT_350, Benefit_RT_600=Benefit_RT_600, Benefit_RT_1000=Benefit_RT_1000,
                      Cost_RT_50=Cost_RT_50, Cost_RT_150=Cost_RT_150, Cost_RT_350=Cost_RT_350, Cost_RT_600=Cost_RT_600, Cost_RT_1000=Cost_RT_1000)                   
      
  
write_clip(df_1)       
write_clip(df_2) 
write_clip(df_3) 
write_clip(df_4) 
write_clip(df_5) 

                      