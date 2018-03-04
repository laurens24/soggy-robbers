library(dplyr)

# Holds all of Chicago's crime tuples with their ID, Date occured, 
#   if the crime was violent, and the location in (Lat., Long.)
chicago.data <- read.csv('data/chicago_crime.csv', 
                         stringsAsFactors = FALSE) %>%
                # Add a boolean column "Violent" for if the crime was 
                #   violent & change Date to be a date object
                mutate(Violent = Primary.Type %in% c("ROBBERY",
                                                     "ASSAULT",
                                                     "SEX OFFENSE",
                                                     "CRIM SEXUAL ASSAULT",
                                                     "HOMICIDE"),
                       Date = as.Date(Date, "%m/%d/%Y")) %>%
                # Remove the column used to calculate "Violent"
                select(-Primary.Type)

head(chicago.data)

write.csv(chicago.data, "data/Chicago_Crime_Data.csv")
