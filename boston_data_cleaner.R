library(dplyr)
boston.data <- read.csv('data/boston_crime.csv', stringsAsFactors = FALSE)
boston.data <- filter(boston.data, substring(OCCURRED_ON_DATE, 1, 4) == '2016' | 
                        substring(OCCURRED_ON_DATE, 1, 4) == '2017' | 
                        substring(OCCURRED_ON_DATE, 1, 4) == '2018') 
boston.data <- select(boston.data, INCIDENT_NUMBER, OFFENSE_CODE_GROUP, 
                      OFFENSE_DESCRIPTION, SHOOTING, OCCURRED_ON_DATE, Location)

boston.data[boston.data$OFFENSE_DESCRIPTION == "THREATS TO DO BODILY HARM", "OFFENSE_CODE_GROUP"] = 
  "Threats to do bodily harm"
boston.data <- mutate(boston.data, Violent = SHOOTING == 'Y')

boston.data$Violent = boston.data$OFFENSE_CODE_GROUP == "Threats to do bodily harm" | 
  boston.data$OFFENSE_CODE_GROUP == "Aggravated Assault" | boston.data$OFFENSE_CODE_GROUP == "Arson" |
  boston.data$OFFENSE_CODE_GROUP == "Residential Burglary" | 
  boston.data$OFFENSE_CODE_GROUP == "HOME INVASION"|  boston.data$OFFENSE_CODE_GROUP ==  "Simple Assault"| 
  boston.data$OFFENSE_CODE_GROUP == "Ballistics" | boston.data$OFFENSE_CODE_GROUP == "Vandalism"|
  boston.data$OFFENSE_CODE_GROUP == "Firearm Violations" | boston.data$OFFENSE_CODE_GROUP == "Restraining Order Violations" |
  boston.data$OFFENSE_CODE_GROUP == "Offenses Against Child / Family" |
  boston.data$OFFENSE_CODE_GROUP == "Criminal Harassment" | boston.data$OFFENSE_CODE_GROUP == "Bomb Hoax" | 
  boston.data$OFFENSE_CODE_GROUP == "Biological Threat" | boston.data$OFFENSE_CODE_GROUP == "Explosives"| 
  boston.data$OFFENSE_CODE_GROUP == "Homicide"| boston.data$OFFENSE_CODE_GROUP == "Burglary - No Property Taken"
  
colnames(boston.data)[colnames(boston.data) == "OFFENSE_CODE_GROUP"] <- "Short.Description"

boston.data <- mutate(boston.data, Datetype = as.Date(substr(boston.data$OCCURRED_ON_DATE, 1, 10), '%Y-%m-%d'))

colnames(boston.data)[colnames(boston.data) == "Datetype"] <- "Date"

boston.data <- filter(boston.data, Date <= as.Date("02/08/2018", "%m/%d/%Y"))

boston.data <- select(boston.data, Short.Description, Date, Location, Violent)

write.csv(boston.data, "data/Boston_Crime_Data.csv")
