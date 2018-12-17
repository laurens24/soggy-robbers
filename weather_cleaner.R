source("setup.R")

cities.used <- c("BOSTON 0.5 WSW, MA US",
                "CHICAGO 4.7 NE, IL US",
                "SAN FRANCISCO 1.1 SW, CA US",
                "SANTA MONICA 1.3 NNE, CA US")

read.csv("data/othercities_weather.csv", stringsAsFactors = FALSE) %>%
    bind_rows(read.csv("data/LAsantamonica_weather.csv", stringsAsFactors = FALSE)) %>%
    filter(NAME %in% cities.used) %>%
    mutate(Date = as.Date(DATE)) %>%
    select(Station = STATION, 
           Name = NAME,
           Date,
           Precipitation = PRCP) %>%
    write_feather("data/all_weather.feather")
