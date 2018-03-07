library("shiny")
library(ggplot2)
library(dplyr)
library(ggmap)

GetX <- function(coordinates) {
  vector.coordinates <- unlist(strsplit(coordinates, ","))
  x <- vector.coordinates[1]
  x <- substr(x, 2, nchar(x))
  return(as.numeric(x))
}

GetY <- function(coordinates) {
  vector.coordinates <- unlist(strsplit(coordinates, ","))
  y <- vector.coordinates[2]
  y <- substr(y, 1, nchar(y) - 1)
  return(as.numeric(y))
}

# Returns the map 
GetMap <- function(crime.with.weather, violence, max, min, map) {
  if(violence == "Violent") {
    crime.with.weather <- crime.with.weather %>% filter(Violent == TRUE)
  } else if(violence == "Nonviolent") {
    crime.with.weather <- crime.with.weather %>% filter(Violent == FALSE)
  }
  crime.with.weather <- crime.with.weather %>% filter(PRCP <= max & PRCP >= min)
  length <- nrow(crime.with.weather)
  if(length >= 200) {
    points <- crime.with.weather[sample(length, 200), ]
  } else {
    points <- crime.with.weather
  }
  
  p <- ggmap(map) +
    geom_point(data = points, aes(x = long, y = lat))
  return(p)
}



my.server <- function(input, output) {
  
  violence <- reactive ({
    return (input$violence)
  })
  
  max.precip <- reactive ({
    return (input$precip[2])
  })
  
  min.precip <- reactive({
    return (input$precip[1])
  })
  
  
  
  ############### BOSTON #################
  
  ############## SAN FRAN ###############
  # SF Data Manipulation
  san.fran.crime <- read.csv("data/san_francisco_crime.csv", stringsAsFactors = FALSE)
  san.fran.crime$lat <- sapply(san.fran.crime$Location, GetX)
  san.fran.crime$long <- sapply(san.fran.crime$Location, GetY)
  
  sf.weather <- read.csv("data/othercities_weather.csv", stringsAsFactors = FALSE)
  sf.weather <- sf.weather %>% filter(STATION == "US1CASF0004")
  sf.weather <- sf.weather %>% mutate(as.date = as.Date(DATE))
  
  output$SF.map <- renderPlot({
    
    violence <- violence()
    max.precip <- max.precip()
    min.precip <- min.precip()
    
    map <- get_map("san francisco, california", zoom = 12)
    
    san.fran.crime <- left_join(san.fran.crime, sf.weather, by=c("Date" = "DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    return(GetMap(san.fran.crime, violence, max.precip, min.precip, map))
    
  })
  
  
  ############# LA #################
  
  ############# CHICAGO ############
  
  
}

