library(dplyr)

sfdata <- read.csv("data/sf_crime.csv", stringsAsFactors = FALSE)
View(sfdata)

sfrow <- sfdata[1, ]
View(sfrow)
year <- sfrow$Date


data <- sfdata %>% filter(substr(Date, 7, 12) == "2016" |
                            substr(Date, 7, 12) == "2017" |
                            substr(Date, 7, 12) == "2018") %>% 
  select(IncidntNum, Category, Descript, Date, Location)

data <- data %>% mutate(Datetype = as.Date(Date, format="%m/%d/%Y"))

data <- data %>% filter(Datetype <= as.Date("02/08/2018", format="%m/%d/%Y"))
  
unique(data$Category)

violent <- c("ASSAULT", "SEX OFFENSES, FORCIBLE", "ROBBERY", "BURGLARY", "SECONDARY CODES")

data <- data %>% mutate(Violent = (Category == violent[1] | Category == violent[2] | Category == violent[3] | Category == violent[4]
                                   | Category == violent[5])) %>% 
  select(IncidntNum, Datetype, Location, Violent)

colnames(data) = c("ID", "Date", "Location", "Violent")

write.csv(data, "data/san_francisco_crime.csv")
