library(forecast)
library(glmnet)

setwd('C:/Users/Frank/Desktop/Data Science Cert/Udacity/Intro_to_Data_Science/UdacityIntroToDataScience/Lesson 3')

df <- read.csv('turnstile_data_master_with_weather.csv')

# Linear regression fitting using default question values
dmodel1 <- lm(ENTRIESn_hourly~
               rain +
               precipi +
               Hour +
               meantempi, data=df)

summary(dmodel1)

# Linear regression using custom method
dfSubset <- df[,7:ncol(df)]
cmodel1 <- lm(ENTRIESn_hourly~., dfSubset)
cmodel1 <- update(cmodel1, .~.-EXITSn_hourly)
summary(cmodel1)

cmodel1 <- update(cmodel1, .~.-fog)
summary(cmodel1)

cmodel1 <- update(cmodel1, .~.-mindewpti)
summary(cmodel1)

cmodel1 <- update(cmodel1, .~.-meandewpti)
summary(cmodel1)

cmodel1 <- update(cmodel1, .~.-thunder)
summary(cmodel1)

cmodel1 <- update(cmodel1, .~.-maxtempi)
summary(cmodel1)

# Sig variables are:
#   maxpressurei,
#   maxdewpti,
#   minpressurei,
#   meanpressurei,
#   rain,
#   meanwindspdi,
#   mintempi,
#   meantempi,
#   precipi


# Rought Plotting
#default
plot(df$ENTRIESn_hourly, type="l", xaxt="n")
par(new=TRUE)
plot(fitted.values(dmodel1),type="l", col="red",xaxt="n")

#Custom
plot(df$ENTRIESn_hourly, type="l", xaxt="n")
par(new=TRUE)
plot(fitted.values(cmodel1),type="l", col="red",xaxt="n")

# Testing accuracy
a1 <- accuracy(df$ENTRIESn_hourly,fitted.values(dmodel1))
a2 <- accuracy(df$ENTRIESn_hourly,fitted.values(cmodel1))

#Using LASSO Regression
x1 <- df[,4:ncol(df)]
x1$DESCn <- NULL
x1$ENTRIESn_hourly <- NULL
x1$EXITSn_hourly <- NULL
x1$TIMEn <- as.factor(x1$TIMEn)
x1$Hour <- as.factor(x1$Hour)

y1 <- df$ENTRIESn_hourly

x1 <- data.matrix(x1)
y1 <- as.matrix(y1)

fit <- glmnet(x1, y1, alpha=1)
plot(fit, label=TRUE)
# Each curve corresponds to a variable. It shows the path of its coefficient against l1-norm of the whole 
# coefficient vector at as lambda varies. The axis above indicates the number of nonzero coefficients @ the
# current lambda, which is the effective degrees of freedom(df) for the lasso

print(fit)
# It shows from left to right the number of non-0 coefficients (DF), % of null deviance explained (%dev),
# and the value of lambda. Although by default glmdefault calls for 100 values of lambda, the program
# stops early if %dev% does not change sufficientnly from one lambda to the next.

coef(fit, s=0.1)
# Shows the coefficents Lasso found

# crossvalidation
cvfit = cv.glmnet(x1,y1)
plot(cvfit)

#finding the min mean cross validation error
cvfit$lambda.min
coef(cvfit, s='lambda.1se')
coef(cvfit, s='lambda.min')

#The variables using GLMNET
# TIMEn,
# Hour,
# maxpressurei,
# maxdewpti,
# fog,
# rain,
# meanwindspdi,
# mintempi,
# maxtempi

predictions <- predict(cvfit, newx=x1, s='lambda.min')

plot(df$ENTRIESn_hourly, type="l", xaxt="n")
par(new=TRUE)
plot(predictions,type="l", col="red",xaxt="n")

predictions <- as.data.frame(predictions)
df <- cbind(df, predictions)
accuracy(df$ENTRIESn_hourly, df[,23])
