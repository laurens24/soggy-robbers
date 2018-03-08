library("dplyr")

la.crime <- read.csv("data/la_crime.csv", stringsAsFactors = FALSE)

# selects relevant data
clean.la.crime <- select(la.crime, DR.Number, Date.Occurred, Crime.Code.Description, Location) %>%
                  # determines which crimes are violent and creates a new column denoting violence of a crime
                  mutate(Violent = (grepl("ASSAULT", Crime.Code.Description) | grepl("HOMICIDE", Crime.Code.Description) |
                                    grepl("ROBBERY", Crime.Code.Description) | grepl("BATTERY", Crime.Code.Description) |
                                    grepl("BURGLARY", Crime.Code.Description)| grepl("MURDER", Crime.Code.Description) |
                                    grepl("RAPE", Crime.Code.Description) | grepl("SEXUAL", Crime.Code.Description)) ) %>%
                  # changes date type
                  mutate(Date = as.Date(Date.Occurred, "%m/%d/%Y")) %>%
                  # chooses data from 2016 to Feb 8 2018
                  filter(grepl("2016", Date.Occurred) | grepl("2017", Date.Occurred) | grepl("2018", Date.Occurred)) %>%
                  filter((DR.Number != 171013348) & (DR.Number != 171013326)) %>%
                  # selects relevant data
                  select(Crime.Code.Description, Date, Location, Violent) 

# renames columns to the universal labels
colnames(clean.la.crime) <- c("Short.Description", "Date", "Location", "Violent")

write.csv(clean.la.crime, "data/los_angeles_crime.csv")