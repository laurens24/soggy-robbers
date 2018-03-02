library("ggplot2")
library("dplyr")

la.crime <- read.csv("data/la_crime.csv", stringsAsFactors = FALSE)
clean.la.crime <- select(la.crime, DR.Number, Date.Occurred, Crime.Code.Description, Location) %>%
                  mutate(Violent = (grepl("ASSAULT", Crime.Code.Description) | grepl("HOMICIDE", Crime.Code.Description) |
                                    grepl("ROBBERY", Crime.Code.Description) | grepl("BATTERY", Crime.Code.Description) |
                                    grepl("BURGLARY", Crime.Code.Description)| grepl("MURDER", Crime.Code.Description) |
                                    grepl("RAPE", Crime.Code.Description) | grepl("SEXUAL", Crime.Code.Description)) ) %>%
                  mutate(Date = as.Date(Date.Occurred, "%m/%d/%Y")) %>%
                  filter(grepl("2016", Date.Occurred) | grepl("2017", Date.Occurred) | grepl("2018", Date.Occurred)) %>%
                  filter((DR.Number != 171013348) & (DR.Number != 171013326)) %>%
                  select(DR.Number, Date, Location, Violent) 
colnames(clean.la.crime) <- c("ID", "Date", "Location", "Violent")

write.csv(clean.la.crime, "data/los_angeles_crime.csv")