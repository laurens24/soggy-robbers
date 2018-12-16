source("setup.R")

# 'la_crime.csv' sourced from https://data.lacity.org/A-Safe-City/Crime-Data-from-2010-to-Present/y8tr-7khq

violent.categories <- c("ASSAULT", 
                        "HOMICIDE",
                        "ROBBERY", 
                        "BATTERY", 
                        "BURGLARY", 
                        "MURDER", 
                        "RAPE", 
                        "SEXUAL")

read.csv("data/la_crime.csv", stringsAsFactors = FALSE) %>%
    rename(ID = DR.Number,
           Date = Date.Occurred,
           Description = Crime.Code.Description) %>%
    filter(Location != "" & Location != "(0, 0)") %>%
    mutate(Date = as.Date(Date, "%m/%d/%Y")) %>%
    filter(Date >= as.Date("2016-01-01") & Date <= as.Date("2018-02-08")) %>%
    mutate(Latitude = GetX(Location),
           Longitude = GetY(Location),
           Violent = Description %in% violent.categories) %>%
    select(ID, Date, Latitude, Longitude, Violent, Description) %>%
    write_feather("data/la_crime.feather")
