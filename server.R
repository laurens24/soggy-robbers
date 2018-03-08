library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)

# Calculates and returns the first coordinate in a set 
# of latitude/longitude coordinates (typically the latitude)
#
# Args:
#   - coordinates: a string representing coordinates in the format
#                 (coordinate1, coordinate2)
#
# Returns:
#     a numeric value representing the first coordinate in the
#     given string
GetX <- function(coordinates) {
  vector.coordinates <- unlist(strsplit(coordinates, ","))
  x <- vector.coordinates[1]
  x <- substr(x, 2, nchar(x))
  return(as.numeric(x))
}

# Calculates and returns the second coordinate in a set 
# of latitude/longitude coordinates (typically the longitude)
#
# Args:
#   - coordinates: a string representing coordinates in the format
#                 (coordinate1, coordinate2)
#
# Returns:
#     a numeric value representing the second coordinate in the
#     given string
GetY <- function(coordinates) {
  vector.coordinates <- unlist(strsplit(coordinates, ","))
  y <- vector.coordinates[2]
  y <- substr(y, 1, nchar(y) - 1)
  return(as.numeric(y))
}

# Calculates and returns a leaflet map with clickable crime data. If the filters
# applied result in a crime set with more than 200 values, a random selection
# of the crimes are chosen to be plotted on the map. Otherwise, all crimes are
# plotted on the map.
#
# Args:
#     - crime.with.weather: a dataframe with crime and weather information. This dataframe
#       should contain the following columns - Short.Description, PRCP, Violent(boolean),
#       long, lat
#     - violence: either "Violent", "Nonviolent", or another value representing both
#     - max: the maximum precipitation amount selected by the user
#     - min: the minimum precipitation amount selected by the user
#     - longitude: the longitude of the center of the city being mapped
#     - latitude: the latitude of the center of the city being mapped
#     - zoom: the zoom level for the map to display as its default
#
# Returns:
#     a leaflet map that shows the city in question with up to 200 crime points.
#     the crime points can be clicked and a short description of each crime is shown
GetMap <- function(crime.with.weather, violence, max, min, longitude, latitude, zoom) {
  # filter for violent or nonviolent crimes, if selected by the user
  if(violence == "Violent") {
    crime.with.weather <- crime.with.weather %>% filter(Violent == TRUE)
  } else if(violence == "Nonviolent") {
    crime.with.weather <- crime.with.weather %>% filter(Violent == FALSE)
  }
  
  # filter for precipitation
  crime.with.weather <- crime.with.weather %>% filter(PRCP <= max & PRCP >= min)
  
  # get sample of 200 crimes, if there are that many
  length <- nrow(crime.with.weather)
  if(length >= 200) {
    points <- crime.with.weather[sample(length, 200), ]
  } else {
    points <- crime.with.weather
  }
  
  # create leaflet map with plotted and interactive crimes
  p <- leaflet() %>% addProviderTiles(providers$OpenStreetMap.HOT) %>% setView(longitude, latitude, zoom = zoom) %>% 
    addCircleMarkers(data = points, lng = ~ long, lat = ~ lat, radius = 2, popup = ~ Short.Description)
  return(p)
}

GetBar <- function(crime, weather, max, min, violence) {
  # Groups all of the Violent Crimes and totals each day
  avg.violent <- filter(crime, Violent == TRUE) %>% 
                 group_by(Date) %>% 
                 summarize(Violent.total = n())
  
  # Groups all of the Nonviolent Crimes and totals each day
  avg.nonviolent <- filter(crime, Violent == FALSE) %>% 
                    group_by(Date) %>% 
                    summarize(Nonviolent.total = n())
  
  # Groups both Nonviolent and Violent Crimes and totals each day
  avg.both <- group_by(crime, Date) %>% 
              summarize(Both.total = n())
  
  colnames(weather) <- c("Station", "Name", "Date", "PRCP")
  
  # Use the data from the radio buttons to determine which data to use
  avg.value = "0"
  if (violence == "Violent") {
    avg.value <- "Violent.total" %>% rlang::sym()
    data.in.question <- avg.violent
  } else if (violence == "Nonviolent") {
    avg.value <- "Nonviolent.total" %>% rlang::sym()
    data.in.question <- avg.nonviolent
  } else {
    avg.value <- "Both.total" %>% rlang::sym()
    data.in.question <- avg.both
  }
  
  # The data which will be plotted
  data.in.question <- left_join(data.in.question, weather, by = "Date")
  
  # Creates breaks, which is a vector of the seperations that the
  #   precipitation will be partitioned by.
  max.num <- max(data.in.question$PRCP, na.rm = TRUE)
  break.point <- ((max - min) / 5)
  first.point <- min + break.point
  breaks <- seq(first.point, max, break.point)
  
  # Takes in a precipitation value and uses the breaks calculated to
  #   determine which partition the value belongs in.
  determine.break <- function(prcp) {
    point <- 0
    
    ifelse(prcp <= breaks[1], 
           point <- paste0(min, " - ", breaks[1]), 
           ifelse(prcp <= breaks[2], 
                  point <- paste0(breaks[1], " - ", breaks[2]),
                  ifelse(prcp <= breaks[3], 
                         point <- paste0(breaks[2], " - ", breaks[3]),
                         ifelse(prcp <= breaks[4], 
                                point <- paste0(breaks[3], " - ", breaks[4]),
                                ifelse(prcp <= breaks[5], 
                                       point <- paste0(breaks[4],
                                                       " - ", 
                                                       breaks[5]), 
                                       point <- 0)))))
  }
  
  data.in.question <- data.in.question %>% 
                      mutate(
                        points = determine.break(data.in.question$PRCP)) %>%
                      filter(!is.na(points))
  
  # Selects the color of the bars; Red for Violent, Blue for Nonviolent,
  #   and Purple for Both.
  crime.color <- "white"
  if (violence == "Violent") {
    crime.color <- "red"
  } else if (violence == "Nonviolent") {
    crime.color <- "blue"
  } else {
    crime.color <- "purple"
  }
  
  data.in.question <- data.in.question %>% 
                      select(PRCP, !!avg.value, points)
  # Calculate average crimes on days with the same rain-level
  prcp.group <- group_by(data.in.question, points) %>% 
                summarize(average = (sum(!!avg.value) / n()))

  # Generate Plot
  la.bar <- ggplot(prcp.group) +
    geom_bar(mapping = aes(x = points, y = average), 
             stat="identity", 
             fill = crime.color) +
    geom_text(aes(x = points, y = average, 
                  label=round(average, digits = 2), vjust=-0.25)) +
    labs(title = paste0("Average Number of ", violence, 
                        " Crimes vs Precipitation Levels"),
         x = "Precipitation", 
         y = "Average number of crimes")
  
  return(la.bar)
}

my.server <- function(input, output) {
  
  # returns user's violence filter selection
  violence <- reactive ({
    violence <- c(input$violence.b, input$violence.sf, input$violence.la, input$violence.c)
    return (violence)
  })
  
  # return user's selection for maxiumum precipitation level in each city
  max.precip <- reactive ({
    precip <- c(input$precip.b[2], input$precip.sf[2], input$precip.la[2], input$precip.c[2])
    return (precip)
  })

  # return user's selection for minimum precipitation level in each city
  min.precip <- reactive({
    precip <- c(input$precip.b[1], input$precip.sf[1], input$precip.la[1], input$precip.c[1])
    return (precip)
  })

  all.weather <- read.csv("data/othercities_weather.csv", stringsAsFactors = FALSE)
    
  ############### BOSTON #################
  
  # Clean and join data before generating graph and map
  boston.crime <- read.csv("data/Boston_Crime_Data.csv", stringsAsFactors = FALSE)
  boston.crime$lat <- sapply(boston.crime$Location, GetX)
  boston.crime$long <- sapply(boston.crime$Location, GetY)
  
  boston.weather <- all.weather %>% filter(STATION == "US1MASF0001")
  boston.crime.with.weather <- left_join(boston.crime, boston.weather, by=c("Date" = "DATE")) %>% 
    distinct(X, .keep_all = TRUE)
  boston.weather <- boston.weather[, 1:4]
  boston.weather <- boston.weather %>% filter(!is.na(PRCP))
  
  output$Boston.bar <- renderPlot({
    return(GetBar(boston.crime, boston.weather, max.precip()[1], min.precip()[1], violence()[1]))
  })
  
  output$Boston.map <- renderLeaflet({
    return(GetMap(boston.crime.with.weather, violence()[1], max.precip()[1], min.precip()[1], -71.06, 42.36, 12))
  })
  
  ############## SAN FRAN ###############
  
  # Clean and join data before generating graph and map
  san.fran.crime <- read.csv("data/san_francisco_crime.csv", stringsAsFactors = FALSE)
  san.fran.crime$lat <- sapply(san.fran.crime$Location, GetX)
  san.fran.crime$long <- sapply(san.fran.crime$Location, GetY)
  
  sf.weather <- all.weather %>% filter(STATION == "US1CASF0004")
  sf.crime.with.weather <- left_join(san.fran.crime, sf.weather, by=c("Date" = "DATE")) %>% 
    distinct(ID, .keep_all = TRUE)
  sf.weather <- sf.weather[, 1:4]
  sf.weather <- sf.weather %>% filter(!is.na(PRCP))
  
  output$SF.bar <- renderPlot({
    return(GetBar(san.fran.crime, sf.weather, max.precip()[2], min.precip()[2], violence()[2]))
  })
  
  output$SF.map <- renderLeaflet({
    return(GetMap(sf.crime.with.weather, violence()[2], max.precip()[2], min.precip()[2], -122.42, 37.78, 12))
  })
 
  ############# LA #################
  
  # Clean and join data before generating graph and map
  la.crime <- read.csv("data/los_angeles_crime.csv", stringsAsFactors = FALSE)
  la.crime <- filter(la.crime, Date <= as.Date("02/08/2018", format="%m/%d/%Y"))
  la.weather <- read.csv("data/LAsantamonica_weather.csv", stringsAsFactors = FALSE)
  la.weather <- filter(la.weather, !is.na(PRCP))
  
  output$LA.bar <- renderPlot({
    GetBar(la.crime, la.weather, max.precip()[3], min.precip()[3], violence()[3])
  })
  
  la2.crime <- read.csv("data/los_angeles_crime.csv", stringsAsFactors = FALSE)
  la2.crime$lat <- sapply(la2.crime$Location, GetX)
  la2.crime$long <- sapply(la2.crime$Location, GetY)
  
  output$LA.map <- renderLeaflet({
    
    la2.crime <- left_join(la2.crime, la.weather, by= c("Date"="DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    return(GetMap(la2.crime, violence()[3], max.precip()[3], min.precip()[3], -118.2437, 34.0522, 10))
    
  })

  ############# CHICAGO ############
  
  # Clean and join data before generating graph and map
  ch.crime <- read.csv("data/Chicago_Crime_Data.csv", stringsAsFactors = FALSE)
  ch.crime$lat <- sapply(ch.crime$Location, GetX)
  ch.crime$long <- sapply(ch.crime$Location, GetY)

  ch.weather <- all.weather %>% 
                filter(NAME == "CHICAGO 4.7 NE, IL US")
  
  ch.weather <- ch.weather[, 1:4]
  
  output$Chicago.bar <- renderPlot({
    return(GetBar(ch.crime, ch.weather, max.precip()[4], min.precip()[4], violence()[4]))
  })

  output$Chicago.map <- renderLeaflet({
    
    ch.crime <- left_join(ch.crime, ch.weather, by=c("Date" = "DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    return(GetMap(ch.crime, violence()[4], max.precip()[4], min.precip()[4], -87.6298, 41.8781, 10))
    
  })
}
