library(dplyr)

boston.data <- read.csv('data/boston_crime.csv', stringsAsFactors = FALSE)

# narrows to crimes that have happened between 2016 and 2018
boston.data <- filter(boston.data, substring(OCCURRED_ON_DATE, 1, 4) == '2016' | 
                        substring(OCCURRED_ON_DATE, 1, 4) == '2017' | 
                        substring(OCCURRED_ON_DATE, 1, 4) == '2018') 

# gets rid of columns of data that we don't use
boston.data <- select(boston.data, INCIDENT_NUMBER, OFFENSE_CODE, OFFENSE_CODE_GROUP, 
                      OFFENSE_DESCRIPTION, OCCURRED_ON_DATE, Location)

# all crimes with codes below 600 are not defined as violent by the FBI
boston.data$Violent = boston.data$OFFENSE_CODE < 600

# renames the description to our universal name
colnames(boston.data)[colnames(boston.data) == "OFFENSE_CODE_GROUP"] <- "Short.Description"

# converts the date string to a date type
boston.data <- mutate(boston.data, Datetype = as.Date(substr(boston.data$OCCURRED_ON_DATE, 1, 10),
                                                      '%Y-%m-%d'))
# renames the date column
colnames(boston.data)[colnames(boston.data) == "Datetype"] <- "Date"

# makes Feb 8 2018 the latest date that returns data
boston.data <- filter(boston.data, Date <= as.Date("02/08/2018", "%m/%d/%Y"))

# selects the relevant information
boston.data <- select(boston.data, Short.Description, Date, Location, Violent)

write.csv(boston.data, "data/Boston_Crime_Data.csv")
