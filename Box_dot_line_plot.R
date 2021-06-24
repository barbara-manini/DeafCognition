#OVERLAPPING BOX, DOT AND LINES

library(ggplot2)

Data_taskswitching$ID <- as.factor(Data_taskswitching$ID)
Data_taskswitching$Group<-factor(Data_taskswitching$Group, labels = c("Hearing","Deaf"))
Data_taskswitching$Condition<-factor(Data_taskswitching$Condition, labels = c("Stay","Switch"))

TS=ggplot(Data_taskswitching, aes( Condition, R_STC, fill=Group))


TS + geom_boxplot(outlier.colour="red", outlier.shape=8, outlier.size=4)+
  geom_point()+
  ggtitle("Task switching: Right superior temporal cortex")+
  scale_fill_manual(values=c("darkturquoise", "coral2"))+
  geom_line(aes(group = ID))+
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=32, hjust=0.7))+
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=22))+
  theme(legend.text=element_text(size=18))+
  theme(text = element_text(size=30))+ 
  theme_bw()+
  facet_grid(.~Group) 

