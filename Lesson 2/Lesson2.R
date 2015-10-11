setwd('C:/Users/Frank/Desktop/Data Science Cert/Udacity/Intro_to_Data_Science/UdacityIntroToDataScience/Lesson 2')

# Weather Underground csv
df <- read.csv('weather_underground.csv')

# Turnstile info csv
beforeDF <- read.csv('turnstile_110528.txt', header=FALSE)
afterDF <- read.csv('solution_turnstile_110528.txt', header=FALSE)
