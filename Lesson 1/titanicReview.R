library(ggplot2)
library(dplyr)

setwd('C:/Users/Frank/Desktop/Data Science Cert/Udacity/Intro to Data Science/UdacityIntroToDataScience/Lesson 1')
df <- read.csv('titanic_data.csv')
df$Survived <- as.factor(df$Survived)



#3rd Quartile
thirdQT <- summary(df$Fare)[[5]]

dfSubset1 <- subset(df, (df$Sex == 'female') | (df$Pclass==1 & df$Age < 18))
Missed1 <- subset(dfSubset1, dfSubset1$Survived==0)

dfSubset2 <- subset(df, (df$Sex == 'female') | (df$Pclass<3 & df$Age < 18) | df$Fare > 300)
Missed2 <- subset(dfSubset2, dfSubset2$Survived==0)

ggplot(aes(x=Survived, y=Fare, fill=Survived), data=df) +
  geom_boxplot() +
  facet_wrap(~Sex)

by(df$Fare, df$Survived, summary)
