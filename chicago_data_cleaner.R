source("setup.R")

# Holds all of Chicago's crime tuples with their ID, Date occured, 
#   if the crime was violent, and the location in (Lat., Long.)
chicago.data <- read.csv('data/chicago_crime.csv', 
                         stringsAsFactors = FALSE)

chicago.data <- filter(chicago.data, Location != "")

chicago.data$Latitude = sapply(chicago.data$Location, GetX)
chicago.data$Longitude = sapply(chicago.data$Location, GetY)

chicago.data <- chicago.data %>%
    # Add a boolean column "Violent" for if the crime was 
    #   violent & change Date to be a date object
    mutate(Violent = Primary.Type %in% c("ROBBERY",
                                         "ASSAULT",
                                         "SEX OFFENSE",
                                         "CRIM SEXUAL ASSAULT",
                                         "HOMICIDE"),
           Date = as.Date(Date, "%m/%d/%Y"),
           Description = Primary.Type) %>%
    filter(Date <= "2018-02-08")

# Write the data in [ID, Date, Lat, Long, Violent, Description]
write_feather(chicago.data[, c(1,2,5,6,7,8)], "data/chicago_crime.feather")
