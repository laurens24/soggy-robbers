source("setup.R")

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
                       Date = as.Date(Date, "%m/%d/%Y"),
                       Description = Primary.Type,
                       Lat = GetX(Location),
                       Long = GetY(Location)) %>%
                select(-Location) %>%
                filter(Date <= "2018-02-08")

write_feather(chicago.data, "data/Chicago_Crime.feather")
