###########################################################################
# This script shows the application of regressions for data analysis.     #
# Regression types used: linear, log-linear, power, polynomial, kernel    #
# Data: corporate bond default data available on Moody's Investor Service #
# Script created: Q2 2017                                                 #
###########################################################################

# Install and load packages 
install.packages('np')
install.packages('ggplot2')
install.packages('tidyverse')

library(np)
library(tidyverse)
library(ggplot2)


###### CLEAR VARIABLES AND CONSOLE, LOAD DATA ###### 
rm(list=ls())
data <- read.table("C:/Users/Martin/Google Drive/00_Cloud/09_03_03_04_GitHub_copy/data_1982-2015_V2.0.csv", header=TRUE, sep = ";", na.strings = c(""))


###### ANALIZE THE DATA ######
names(data)
sapply(data, class)
head(data)
View(data)

# Adding new variable LGD for corporate bonds
data["LGD_corp._bond"] <- NA 
data$LGD_corp._bond <- 1 - data$RR_corp._bond; data$LGD_corp._bond
head(data)

# Number of n/a's in total and per variable
sapply(data,function(x) sum(is.na(x)))
sum(apply(data, 2, function(x) sum(is.na(x)))) 

# Number of unique values per variable
apply(data, 2, function(x) length(unique(x))) 
 
# Histogram, Density
ggplot(data = data) + geom_histogram(mapping = aes(x = default_count_IG)) +  xlab("Year")
ggplot(data = data, aes(x = default_count_IG))  + xlab("Year") +  geom_density()

# Compare default rates in a plot
ggplot(data=data) + geom_line(aes(x=year, y=default_count_IG, group=1), color="blue") + geom_line(aes(x=year, y=default_count_SG, group=1), color="red") 

# Basic descriptive statistics
summary(data)

# Outliers
ggplot(data, aes(y = default_count_SG)) + geom_boxplot()

# Correlation
cor(data$PD_SG, data$loss_rate_SG, method = "pearson")
ggplot(data, aes(x=PD_SG, y=loss_rate_SG)) + geom_point() + geom_smooth(method=lm, level=0.99)

# One-way ANOVA: 
anova1 <- aov(data$loss_rate_SG ~ data$PD_SG)
summary(anova1)

#P-value below 0.05, F_value is high => accept H1 and that there is significant relationship between the variables
ggplot(data, aes(x=PD_SG, y=loss_rate_SG)) + geom_point() 

#Two-way ANOVA
anova3 <- aov(data$loss_rate_SG ~
                  data$PD_SG + data$PD_IG 
                  + data$PD_SG:data$PD_IG) #data$PD_SG:data$PD_IG is the interaction between these two variables
summary(anova3)


###### UNIVARIATE REGRESSIONS ######
# Linear regression
reg1 <- lm(data$LGD_corp._bond ~ 
             data$PD_SG,
           data = data)
summary(reg1)
nrow(summary(reg1)$coefficients)

# Define function that creates vector storing the main regression parameters
create_vector <- function(regression) {
  intercept_reg <- summary(regression)$coefficients[1,1]
  regressor1_reg <- summary(regression)$coefficients[2,1]
  if (nrow(summary(regression)$coefficients) <3) {
    regressor2_reg <- NA
  }
  else{
    regressor2_reg <- summary(regression)$coefficients[3,1]
  }
  if (nrow(summary(regression)$coefficients) <4) {
    regressor3_reg <- NA
  }
  else{
    regressor3_reg <- summary(regression)$coefficients[4,1]
  }
  r_squared_reg <- summary(regression)$r.squared
  adj.r_squared_reg <- summary(regression)$adj.r.squared
  F_reg <- as.numeric(summary(regression)$fstatistic[1])
  pvalue_reg <- summary(regression)$coefficients[2,4]
  predictor_reg <- paste(attr(regression$terms, "term.labels"), collapse=";")
  res_reg <- sum(residuals(regression)^2)
  par_reg <- c("bond LGD", predictor_reg, format(round(c(intercept_reg, regressor1_reg, regressor2_reg, 
                                                         regressor3_reg, F_reg, pvalue_reg, r_squared_reg, 
                                                         adj.r_squared_reg, res_reg), 4), digits = 4))
    print(par_reg)
  }	
par_reg1 <- create_vector(reg1)

# Power regression
reg2 <- lm(log(data$LGD_corp._bond, base = exp(1)) ~ 
              log(data$PD_SG, base = exp(1)), data = data)
summary(reg2)

# Create vector storing the main regression parameters with user defined function
par_reg2 <- create_vector(reg2)

# Log-linear regression 
ggplot(data, aes(x=PD_SG)) + geom_density()
ggplot(data, aes(x=log(data$PD_SG))) + geom_density()

reg3 <- lm(data$LGD_corp._bond ~ 
              log(data$PD_SG, base = exp(1)), data = data)
summary(reg3)

# Create vector storing the main regression parameters with user defined function
par_reg3 <- create_vector(reg3)

# Store the regression vectors into tibble
df <- tibble(Regression1 = par_reg1) 
df <- df %>% add_column(Regression2 = par_reg2)
df <- df %>% add_column(Regression3 = par_reg3)
param1 <- c("y","x","a","b1","b2", "b3", "F-stat", "p-value","R^2", "adj.R^2", "SSR")
df <- df %>% add_column(Parameters = param1)
df <- df %>% relocate(Parameters)
df 

# Plotting regression line 1 
x <- seq(0.00, 0.12, by=0.005); x
# Calculate y = a + bx  = intercept + regressor * x
y_reg1 <- as.numeric(par_reg1[3]) + as.numeric(par_reg1[4]) * x 

d_frame <- data.frame(col_1_x=x, col_2_y=y_reg1)
head(d_frame)

# Function creating regression plot
create_plot <- function(dataset) {
  ggplot(dataset, aes(x = col_1_x, y = col_2_y)) + geom_line() + geom_point(data = data, aes(x=PD_SG, y=LGD_corp._bond))
}	

create_plot(d_frame)

# Plotting regression line 2
# Calculate y = e^a * x^b = e^intercept * x^regressor 
y_reg2 <- exp(as.numeric(par_reg2[3])) * x  ^ (as.numeric(par_reg2[4]))

d_frame <- data.frame(col_1_x=x, col_2_y=y_reg2)
head(d_frame)

create_plot(d_frame)

# Plotting regression line 3
# Calculate y = a + blog(x)  = intercept + regressor * log(x)
y_reg3 <- as.numeric(par_reg3[3]) + as.numeric(par_reg3[4]) * log(x)

d_frame <- data.frame(col_1_x=x, col_2_y=y_reg3)
head(d_frame)

create_plot(d_frame)


###### UNIVARIATE KERNEL REGRESSIONs ######
reg4 <- ksmooth(data$PD_SG, data$LGD_corp._bond, kernel = c("normal"), bandwidth = 0.08)
# Plotting Kernel regression
plot (data$PD_SG, data$LGD_corp._bond)
lines(reg4)

reg5 <- npscoef(data$LGD_corp._bond ~ 
            data$PD_SG, regtype = "ll", gradients = TRUE, data = data)
summary(reg5)
# Plotting Kernel regression with R Base
plot(reg5, plot.errors.method = "asymptotic")
points(data$PD_SG, data$LGD_corp._bond, pch=".", cex=4)


##### MULTIVARIATE REGRESSIONS #####
# Checking for multicollinearity
names(data)
cor(data$PD_SG, log(data$PD_SG))
cor(log(data$PD_SG), log(data$PD_SG)^2)
# The explanatory variables with high multicollinearity are higly correlated => no multiple regression with these variables

# Polynomial regression
data$PD_SG_sqr <- (data$PD_SG)^2
data$PD_SG_sqr 

reg6 <- lm(data$LGD_corp._bond ~ 
                data$PD_SG + data$PD_SG_sqr, data = data)
summary(reg6)

par_reg6 <- create_vector(reg6)

# Log-Linear
reg7 <- lm(data$LGD_corp._bond ~ 
                data$PD_SG + log(data$PD_SG, base = exp(1)) + data$default_count_SG, data = data)
summary(reg7)

par_reg7 <- create_vector(reg7)

# store all non-kernel regressions in tibble
df <- df %>% add_column(Regression6 = par_reg6)
df <- df %>% add_column(Regression7 = par_reg7)
df
# From the non-kernel regressions, the highest adjusted R^2 (0,57) has the regression 6 (polynomial regression)

# Plotting regression 6
x <- seq(0.00, 0.12, by=0.005); x
# Calculate y = a + b1 * x + b2 * x  = intercept + regressor1 * x + regressor2 * x
y_reg6 <- as.numeric(par_reg6[3]) + as.numeric(par_reg6[4]) * x + as.numeric(par_reg6[5])  * x * x

d_frame <- data.frame(col_1_x=x, col_2_y=y_reg6)
head(d_frame)

create_plot(d_frame)

# Plotting regression 7
# Calculate y = a + b1 * x + b2 *log(x) + b3 * x  = intercept + regressor1 * x + regressor2 * log(x) + reggressor3 * x
y_reg7 <- as.numeric(par_reg7[3]) + as.numeric(par_reg7[4]) * x + as.numeric(par_reg7[5])  * log(x) + as.numeric(par_reg7[6]) * x

d_frame <- data.frame(col_1_x=x, col_2_y=y_reg7)
head(d_frame)

create_plot(d_frame)


