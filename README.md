# Predicting Term Deposit Subscriptions in Banking
This project was developed as part of an academic research assignment at Queens University Belfast. This project analyzes customer data from a bank’s telephone marketing campaign to identify the most influential factors driving subscriptions to term deposits a key investment product that offers customers a secure way to grow their savings.Using statistical and machine learning techniques in Rstudio, the goal is to help financial institutions design more effective campaigns and improve customer experience.

# Objective
To determine the demographic, occupational, and behavioral factors that influence whether customers subscribe to a term deposit and to apply data-driven methods for improving marketing performance and customer understanding.

# Dataset
Source: Provided BY QUB University.
Type: Bank Marketing campaign dataset.
Observations: 40,641.
Variables: 29
Target variable: Term deposit subscription (yes/No).

# Technology used:
R studio
R language libraries: dplyr, ggplot, caret, corrplot
statistical techniques: ch-square test, correlation analysis.
Machine learning model: Logistics regression.

# Methodology
1. Data cleaning and preprocessing - handled missing values, data normalization, data convertion.
2. Exploratory Data Analysis - Descriptive Statistics, Visualization, correlations analysis.
3. Statistical testing -
   a) chi-square test - to test the dependency between categorical features and outcomes.
   b) correlation analysis - to find relationship between nunericals.
5. split data into train and test set - train(70%) & test (30%).
6. predictive modeling -
   a) Logistical regression model to find significant predictors.
   b) model evaluation metrics such as accuracy, confusion matrix and ROC curve.

# Findings
Occupation, Salary campaign month are the most sognificant factors, whereas gender showed less influencial than economic factors. In future including other factors like age, martial status improves the accuracy level.







