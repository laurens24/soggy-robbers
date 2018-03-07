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


san.fran.crime <- read.csv("data/san_francisco_crime.csv", stringsAsFactors = FALSE)
san.fran.crime$lat <- sapply(san.fran.crime$Location, GetX)
san.fran.crime$long <- sapply(san.fran.crime$Location, GetY)


san.fran.map <- get_map("san francisco, california", zoom = 12)

san.fran.crime <- mutate(san.fran.crime, short.lat = round(lat, 3), short.long = round(long, 3))
san.fran.plot.val <- select(san.fran.crime, short.lat, short.long) %>% 
  distinct(short.long, .keep_all = TRUE)

sf.weather <- read.csv("data/othercities_weather.csv", stringsAsFactors = FALSE)
sf.weather <- sf.weather %>% filter(STATION == "US1CASF0004")
sf.weather <- sf.weather %>% mutate(as.date = as.Date(DATE))


max.precip <- max(sf.weather$PRCP)



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
  output$SF.bar <- renderPlot({
  })
  
  output$SF.map <- renderPlot({
    
    violence <- violence()
    max.precip <- max.precip()
    min.precip <- min.precip()
    
    san.fran.crime <- left_join(san.fran.crime, sf.weather, by=c("Date" = "DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    if(violence == "Violent") {
      san.fran.crime <- filter(san.fran.crime, Violent == TRUE)
    } else if (violence == "Nonviolent") {
      san.fran.crime <- filter(san.fran.crime, Violent == FALSE)
    }
    
    san.fran.crime <- filter(san.fran.crime, PRCP <= max.precip & PRCP >= min.precip)
    length <- nrow(san.fran.crime)
    
    if(length >= 200) {
      san.fran.points <- san.fran.crime[sample(length, 200), ]
    } else {
      san.fran.points <- san.fran.crime
    }
    
    p <- ggmap(san.fran.map, extent = "panel") +
      geom_point(data = san.fran.points, aes(x = long, y = lat))
    return(p)
    
  })
  
  
  ############# LA #################
  
  ############# CHICAGO ############
  
  
}

