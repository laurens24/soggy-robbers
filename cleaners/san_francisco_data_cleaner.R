source("../setup.R")

# 'sf_crime.csv' sourced from https://data.sfgov.org/Public-Safety/Police-Department-Incident-Reports-Historical-2003/tmnf-yvry

violent.categories <- c("ASSAULT", 
                        "SEX OFFENSES, FORCIBLE", 
                        "ROBBERY", 
                        "BURGLARY", 
                        "SECONDARY CODES")

read.csv("../data/sf_crime.csv", stringsAsFactors = FALSE) %>% 
    rename(ID = IncidntNum,
           Latitude = Y,
           Longitude = X,
           Description = Descript) %>% 
    mutate(Date = as.Date(Date, format="%m/%d/%Y")) %>% 
    filter(Date >= as.Date("2016-01-01") & Date <= as.Date("2018-02-08")) %>%
    mutate(Violent = Category %in% violent.categories) %>% 
    select(ID, Date, Latitude, Longitude, Violent, Description) %>%
    write_feather("../data/sf_crime.feather")
