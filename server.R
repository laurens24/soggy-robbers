library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)

san.fran.crime <- read.csv("data/san_francisco_crime.csv", stringsAsFactors = FALSE)
san.fran.crime$lat <- sapply(san.fran.crime$Location, GetX)
san.fran.crime$long <- sapply(san.fran.crime$Location, GetY)


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

san.fran.map <- get_map("san francisco, california", zoom = 12)

san.fran.crime <- mutate(san.fran.crime, short.lat = round(lat, 3), short.long = round(long, 3))
san.fran.plot.val <- select(san.fran.crime, short.lat, short.long) %>% 
  distinct(short.long, .keep_all = TRUE)

ggmap(san.fran.map, extend = "panel") +
  geom_point(data = san.fran.plot.val, aes(x = short.long, y = short.lat))

sf.weather <- read.csv("data/othercities_weather.csv", stringsAsFactors = FALSE)
sf.weather <- sf.weather %>% filter(STATION == "US1CASF0004")
sf.weather <- sf.weather %>% mutate(as.date = as.Date(DATE))


x <- san.fran.plot.val[1, "short.long"]
y <- san.fran.plot.val[1, "short.lat"]

filtered_places <- san.fran.crime %>% filter(short.long = x, short.lat = y)

max.precip <- max(sf.weather$PRCP)






my.server <- function(input, output) {
  
  violence <- reactive ({
    return (input$violence)
  })
  
  max.precip <- reactive ({
    return (input$max.precip)
  })
  
  
  
  ############### BOSTON #################
  
  ############## SAN FRAN ###############
  output$SF.bar <- renderPlot({
    p <- ggplot(data = san.fran.crime[1:100, ]) +
      geom_point(mapping = aes(x = lat, y = long))
    return(p)
  })
  
  output$SF.map <- renderPlot({
    
    violence <- violence()
    max.precip <- max.precip()
    
    san.fran.crime <- left_join(san.fran.crime, sf.weather, by=c("Date" = "DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    if(violence == "Violent") {
      san.fran.crime <- filter(san.fran.crime, Violent == TRUE)
    } else if (violence == "Nonviolent") {
      san.fran.crime <- filter(san.fran.crime, Violent == FALSE)
    }
    
    san.fran.crime <- filter(san.fran.crime, PRCP <= max.precip)
    length <- nrow(san.fran.crime)
    
    if(length >= 200) {
      san.fran.points <- san.fran.crime[sample(length, 200), ]
    } else {
      san.fran.points <- san.fran.crime
    }
    
    p <- ggmap(san.fran.map) +
      geom_point(data = san.fran.points, aes(x = long, y = lat))
    return(p)
    
  })
  
  
  ############# LA #################
  
  ############# CHICAGO ############
  
  
}

