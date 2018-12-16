source("setup.R")

# 'boston_crime.csv' sourced from https://data.boston.gov/dataset/crime-incident-reports-august-2015-to-date-source-new-system

violent.categories <- c("Threats to do bodily harm",
                        "Aggravated Assault", 
                        "Arson",
                        "Residential Burglary",
                        "Simple Assault",
                        "Ballistics",
                        "Offenses Against Child / Family",
                        "Criminal Harassment",
                        "Bomb Hoax",
                        "Homicide",
                        "Burglary - No Property Taken")

Refine <- function(.data, if.col, if.val, res.col, res.val) {
  .data[.data[, if.col] == if.val, res.col] = res.val
  return(.data)
}

read.csv('data/boston_crime.csv', stringsAsFactors = FALSE) %>% 
    rename(ID = INCIDENT_NUMBER,
           Date = OCCURRED_ON_DATE,
           Latitude = Lat,
           Longitude = Long,
           Description = OFFENSE_CODE_GROUP) %>%
    mutate(Date = as.Date(Date)) %>%
    filter(Date >= "2016-01-01" & Date <= "2018-02-08",
           Latitude != -1,
           !is.na(Latitude)) %>%
    Refine("OFFENSE_DESCRIPTION", "THREATS TO DO BODILY HARM", 
           "Description", "Threats to do bodily harm") %>%
    mutate(Violent = Description %in% violent.categories,
           Description = toupper(Description)) %>%
    select(ID, Date, Latitude, Longitude, Violent, Description) %>%
    write_feather("data/boston_crime.feather")
