#Set working directory
setwd("C:/Users/shalinipriya/OneDrive/Documents")

#load packages
library(readxl) # for reading an excel file
library(dplyr)
library(tidyverse)
library(caret)
install.packages("pROC")
library(pROC)

#read term deposit data
data <- read_excel("term.xlsx")

#raw data summary
summary(data)

#data cleaning and formatting
#missing values
data[is.na(data)] <- "unknown"

#count null values
colSums(is,na(data))

#converting target variable to binary
unique(data$subscribed)
data$subscribed <- as.factor(ifelse(data$subscribed == "yes",1,0))
print(data)
table(data$subscribed)
#convert categorical variables to factors
categorical_columns <- c("gender","occupation","salary","month", "previous_campaign_outcome")

data[categorical_columns] <-lapply(data[categorical_columns], as.factor)
data$n_employed <- as.factor(data$n_employed)

#descriptive analysis
summary(data)

#frequency table for categorical variables
table(data$gender)
table(data$occupation)
table(data$salary)
table(data$month)
table(data$previous_campaign_outcome)

data <- data %>%
  mutate(gender = case_when(gender == 'm' ~ "Male", TRUE ~ gender))

data <- data %>%
  filter(occupation != "unknown")
print(data)



data <- data%>%
  mutate(month = tolower(month), 
         month = gsub("march", "mar", month),
         month = factor(month, levels = tolower(month.abb))
  ) %>%
arrange(month)
 print(data)
#cleaned data
##descriptive analysis
 summary(data)
 
 #frequency table for categorical variables
 table(data$gender)
 table(data$occupation)
 table(data$salary)
 table(data$month)
 table(data$previous_campaign_outcome)
 table(data$subscribed)


#Visualizations
#bar plot for subscriptions
 ggplot(data, aes(x = subscribed)) +
   geom_bar(fill = "blue") +
   labs(title = "Subscription Distribution", x = "Subscribed", y = "Count")

#box plot for gender by subscription
ggplot(data, aes(x = as.factor(subscribed), y = gender)) + geom_boxplot(fill = "red") + 
   labs(title = "gender distribution by subscription", x = "subscribed", y = "gender")

#bar plot for occupation by subscription
ggplot(data, aes(x = occupation, fill = as.factor(subscribed))) +
  geom_bar(position = "dodge") +
  labs(title = "Occupation and Subscription Distribution", x = "occupation", y = "Count")


#bar plot for salary by subscription
ggplot(data, aes(x = salary, fill = as.factor(subscribed))) +
  geom_bar(position = "fill") +
  labs(title = "salary and Subscription Distribution", x = "salary", y = "Count")

#bar plot for month by subscription
ggplot(data, aes(x = month, fill = as.factor(subscribed))) +
  geom_bar(position = "stack") +
  labs(title = "month and Subscription Distribution", x = "month", y = "Count")

#bar plot for previous_campaign_outcomes by subscription
ggplot(data, aes(x = previous_campaign_outcome, fill = as.factor(subscribed))) +
  geom_bar(position = "stack") +
  labs(title = "month and Subscription Distribution", x = "month", y = "Count")

#measures of correlation

#correlation for numeric variables
numeric_data <- data %>% select_if(is.numeric)
cor_matrix <- cor(numeric_data)
print(cor_matrix)   

#chi-square test for categorical variables
#for gender and subscribed
chisq_test_result <- chisq.test(table(data$gender, data$subscribed), correct = TRUE)
print(chisq_test_result)


#for occupation and subscribed

occupation_table <- table(data$occupation, data$subscribed)
print(occupation_table)

# Perform Chi-square test
chisq_test <- chisq.test(table(data$occupation, data$subscribed))

# Print expected frequencies
print(chisq_test$expected)


#address sparse or zeros

# Filter out rows with zero counts
filtered_data <- data[data$occupation != "unknown", ]

# Recreate contingency table
occupation_table <- table(filtered_data$occupation, filtered_data$subscribed)

# Perform Chi-square test
chisq_test <- chisq.test(occupation_table)
print(chisq_test)

# for gender, salary, subscribed
#Create a 3-way contingency table
contingency_table <- table(data$gender, data$salary, data$subscribed)
print(contingency_table)
#apply chi-square
# Pairwise Chi-square tests
chisq_gender_subscribed <- chisq.test(table(data$gender, data$subscribed))
chisq_salary_subscribed <- chisq.test(table(data$salary, data$subscribed))
                                                
#Print results
print(chisq_gender_subscribed)
print(chisq_salary_subscribed)

#using vcd


library(vcd)

# Create the contingency table
contingency_table <- table(data$month, data$previous_campaign_outcome, data$subscribed)

# Association statistics
assoc_result <- assocstats(contingency_table)
print(assoc_result)

#split data into training & test sets
set.seed(40459377)
library(caret)

# Split data into training (70%) and testing (30%) sets
train_index <- createDataPartition(data$subscribed, p = 0.7, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]


#logistic regression model
model <- glm(subscribed ~ gender + occupation + salary + month + previous_campaign_outcome , 
             data = train_data, family = binomial)
summary(model)


#predict and evaluate model
# Generate predictions on the test set
test_predictions <- predict(model, test_data, type = "response")

# Convert probabilities to binary predictions (threshold = 0.5)
test_data$predicted <- ifelse(test_predictions > 0.5, 1, 0)

# Confusion matrix
confusion_matrix <- confusionMatrix(as.factor(test_data$predicted), test_data$subscribed)
print(confusion_matrix)
# Calculate accuracy
accuracy <- mean(test_data$predicted == test_data$subscribed)
print(paste("Accuracy:", accuracy))

#calculate  and Plot the AUC-ROC Curve
library(pROC)

roc_obj <- roc(test_data$subscribed, test_predictions)
auc_value <- auc(roc_obj)
print(paste("AUC:", auc_value))

plot(roc_obj, col = "blue", main = "ROC Curve")
