library(dplyr)

sfdata <- read.csv("data/sf_crime.csv", stringsAsFactors = FALSE)

# narrows to crimes that have happened between 2016 and 2018 and selects relevant categories
data <- sfdata %>% filter(substr(Date, 7, 12) == "2016" |
                            substr(Date, 7, 12) == "2017" |
                            substr(Date, 7, 12) == "2018") %>% 
  select(Descript, Category, Descript, Date, Location)

# changes the date format and makes Feb 8 2018 the latest date that returns data
data <- data %>% mutate(Datetype = as.Date(Date, format="%m/%d/%Y"))
data <- data %>% filter(Datetype <= as.Date("02/08/2018", format="%m/%d/%Y"))
  
# creates a vector of terms that are included in violent crimes as determined by th FBI 
violent <- c("ASSAULT", "SEX OFFENSES, FORCIBLE", "ROBBERY", "BURGLARY", "SECONDARY CODES")

# adds a column that states whether a crime is violent or not and selects the relevant data
data <- data %>% mutate(Violent = (Category == violent[1] | Category == violent[2] | Category == violent[3] | Category == violent[4]
                                   | Category == violent[5])) %>% 
  select(Descript, Datetype, Location, Violent)

# renames the columns to be universal
colnames(data) = c("Short.Description", "Date", "Location", "Violent")

write.csv(data, "data/san_francisco_crime.csv")
