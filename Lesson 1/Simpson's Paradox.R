library('reshape2')
library('dplyr')

setwd('C:/Users/Frank/Desktop/Data Science Cert/Udacity/Intro to Data Science/UdacityIntroToDataScience/Lesson 1')
Berkeley <- read.csv('Berkeley.csv')

# Find total number of applications
Berkeley.Sum <- aggregate(Freq ~ Gender+Dept, data=Berkeley, sum)

# Combine to set up calculation for Admitted ratio
Berkeley <- merge(Berkeley, Berkeley.Sum, by=c("Gender", "Dept"))

# Calculate ratio
Berkeley <- transform(Berkeley, Ratio=Freq.x/Freq.y)

# Subset out only admitted
Berkeley.Admitted <- subset(Berkeley, Berkeley$Admit=="Admitted")

# Wide format to show admit ratio between male and female
Berkeley.Admitted.Wide <- dcast(Berkeley.Admitted, Dept~Gender, value.var="Ratio")

# F Test to compare 2 variance
var.test(Berkeley.Admitted.Wide$Female, Berkeley.Admitted.Wide$Male)
# Tabulated F Value for alpha=0.05
qf(0.95, 5,5)
# Obtained P value > 0.05 thus we can assume that the 2 variances are homogeneous. 
# Note that F computed value is < tabulated value.Thus we accept null which is
# true ratio of variances is equal to 1 thus homogeneity of var

# T test
t.test(Berkeley.Admitted.Wide$Female, Berkeley.Admitted.Wide$Male, var.equal=TRUE, paired=FALSE)
# Tabulated T Value for alpha=0.05 (2 tailed)
qt(0.975, 10)
# Obtained P value > 0.05  thus conclude the averages of the 2 groups are significantly similar.
# We fail to reject Null hypothesis. 