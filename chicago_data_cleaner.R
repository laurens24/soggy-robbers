source("setup.R")

# 'chicago_crime.csv' sourced from https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present-Dashboard/5cd6-ry5g

violent.categories <- c("ROBBERY",
                        "ASSAULT",
                        "SEX OFFENSE",
                        "CRIM SEXUAL ASSAULT",
                        "HOMICIDE")

read.csv('data/chicago_crime.csv', stringsAsFactors = FALSE) %>%
    rename(Description = Primary.Type) %>%
    filter(Location != "") %>%
    mutate(Date = as.Date(Date, "%m/%d/%Y")) %>%
    filter(Date >= as.Date("2016-01-01") & Date <= as.Date("2018-02-08")) %>%
    mutate(Latitude = GetX(Location),
           Longitude = GetY(Location), 
           Violent = Description %in% violent.categories) %>%
    select(ID, Date, Latitude, Longitude, Violent, Description) %>%
    write_feather("data/chicago_crime.feather")
