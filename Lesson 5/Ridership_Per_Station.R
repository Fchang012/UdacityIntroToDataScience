setwd('C:/Users/Frank/Desktop/Data Science Cert/Udacity/Intro_to_Data_Science/UdacityIntroToDataScience/Lesson 5')

df <- read.csv('turnstile_data_master_with_weather.csv')

rawDF <- readLines('turnstile_data_master_with_weather.csv')

mapper <- df[, c(2,7,3,4)]

mapper <- mapper[order(mapper$UNIT),]
