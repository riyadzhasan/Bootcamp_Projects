#installs and loads package
install.packages("dplyr")
library(dplyr)

data(airquality) #retrieves R's airquality dataset
aq <- airquality #writes it into a new dataframe called aq, for convenience
rm(airquality) #removes the original dataframe

#gives us some basic insights into the data and its structure
head(aq)
str(aq)

#checks for missing values, replaces them with median values
colSums(is.na(aq))
aq$Ozone <- ifelse(is.na(aq$Ozone), 
                           median(aq$Ozone, na.rm = TRUE), 
                           aq$Ozone)
aq$Solar.R <- ifelse(is.na(aq$Solar.R), 
                             median(aq$Solar.R, na.rm = TRUE), 
                             aq$Solar.R)
colSums(is.na(aq)) #confirms missing values have been replaced

#creates new column for abbreviated months e.g 1,2,3... to Jan, Feb, March
aq$Month_abb <- month.abb[as.integer(aq$Month)]
aq <- aq %>% 
  relocate(Month_abb, .before = Month) #changes new column's position

#changes data type to factor
aq$Month_abb <- as.factor(aq$Month_abb)
aq$Month <- as.factor(aq$Month)
aq$Day <- as.factor(aq$Day)

#creates a new calcuated column
aq <- aq %>%
  mutate(Ozone.Solar.Ratio = round((Ozone / Solar.R), digits = 3))

#changes the position of new calculated column
aq <- aq %>%
  relocate(Ozone.Solar.Ratio, .before = Wind)

#removes duplicates
aq <- filter(aq[!duplicated(aq), ])

#removes outliers that are over 4 standard deviations from the mean (not used so commented out)
#aq <- aq %>%
#  filter(Ozone < mean(Ozone) + 4 * sd(Ozone), 
#         Solar.R < mean(Solar.R) + 4 * sd(Solar.R),
#         Wind < mean(Wind) + 4 * sd(Wind),
#         Temp < mean(Temp) + 4 * sd(Temp)
#  )

#standardises column names - makes all lowercase and replaces . with _
names(aq) <- tolower(names(aq))
names(aq) <- gsub("\\.", "_", names(aq))

#final checks to ensure data is sufficiently cleaned
View(aq)
summary(aq)
str(aq)

#writes cleaned data onto a .csv file
write.csv(aq, "cleaned_air_quality_dataset.csv", row.names = FALSE)
