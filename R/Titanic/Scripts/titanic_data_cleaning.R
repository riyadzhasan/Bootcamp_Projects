#Installs and loads dplys package
install.packages("dplyr")
library(dplyr)

#writes the dataset onto a dataframe
titanic_data <- read.csv("Titanic-Dataset.csv")

View(titanic_data)
#12 columns and 891 rows
#first 2 in names column: Braund, Mr. Owen Harris ;Cumings, Mrs. John Bradley (Florence Briggs Thayer)

summary(titanic_data)
#average passenger age is 29.7
#median fare is 14.45
#177 passengers missing age info

str(titanic_data)
#age in num data type and fare is num data type
#currently no factor data types

#install.packages() is used to install package
#library() is used to load package

#converts column names to lowercase
names(titanic_data) <- tolower(names(titanic_data))

colSums(is.na(titanic_data)) #returns number of missing data entries in column
median(titanic_data$age, na.rm = TRUE)
titanic_data <- titanic_data %>%
  mutate(age = ifelse(is.na(age), median(age, na.rm = TRUE), age))
colSums(is.na(titanic_data)) #verified all missing data has been filled
#177 values were missing from age column, after replacing 0 are missing
#median returns a whole number, which fits the data type of age


#its important to use factor data type as it allows it to be used in analysis
titanic_data <- titanic_data %>% 
  mutate(survived = as.factor(survived), 
         pclass = as.factor(pclass), 
         sex = as.factor(sex),
         embarked = as.factor(embarked)
         ) 

# Remove rows with missing Embarked Values
#titanic_data <- titanic_data %>% filter(!is.na(embarked))
titanic_data <- titanic_data %>%
  filter(embarked != "")

# Drop the Cabin Column
titanic_data <- titanic_data %>% select(-cabin)

#final check to ensure the data is cleaned
View(titanic_data)

#writes the cleaned data onto a csv file we can export
write.csv(titanic_data, "Cleaned_Titanic_Data.csv", row.names = FALSE)
#write
#so we can use it for further steps in analysis such as visualisation for other software like power bi