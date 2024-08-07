#installa and loads necessary packages
install.packages("dplyr")
library(dplyr)

#iris is a dataset including in R so there is no need to read the data from a .csv into a dataframe
#gives us some basic insights into the data and its structure
data(iris)
head(iris)
str(iris)
summary(iris)

#shows missing values
colSums(is.na(iris))
# For demonstration purposes only; actual `iris` dataset has no missing values
iris$Sepal.Length[1] <- NA  # Introduce a missing value
iris$Sepal.Length <- ifelse(is.na(iris$Sepal.Length), mean(iris$Sepal.Length, na.rm = TRUE), iris$Sepal.Length)

#changes data type to factor
iris$Species <- as.factor(iris$Species)

#changes column names to lower cases
names(iris) <- tolower(names(iris))

#replaces / with _ in column names
names(iris) <- gsub("\\.", "_", names(iris)) #replaces dot with underscore

#removes duplicates
iris <- iris[!duplicated(iris), ]

#creates a new calculated column
iris <- iris %>%
  mutate(petal_length_width_ratio = petal_length / petal_width)

#writes the cleaned dataset onto a .csv file
write.csv(iris, "cleaned_iris_dataset.csv", row.names = FALSE)


