library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(ggmap)
library(feather)
library(leaflet)

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

# Returns the leaflet map
GetMap <- function(crime.with.weather, violence, max, min, longitude, latitude, zoom) {
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
  
  p <- leaflet() %>% addProviderTiles(providers$OpenStreetMap.HOT) %>% setView(longitude, latitude, zoom = zoom) %>% 
    addCircleMarkers(data = points, lng = ~ Longitude, lat = ~ Latitude, radius = 2, popup = ~ Description)
  return(p)
}

GetBar <- function(crime, weather, max, min, violence) {
  avg.violent <- filter(crime, Violent == TRUE) %>% group_by(Date) %>% summarize(Violent.total = n())
  
  avg.nonviolent <- filter(crime, Violent == FALSE) %>% group_by(Date) %>% summarize(Nonviolent.total = n())
  
  avg.both <- group_by(crime, Date) %>% summarize(Both.total = n())
  
  colnames(weather) <- c("Station", "Name", "Date", "PRCP")
  
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
  
  data.in.question <- left_join(data.in.question, weather, by = "Date")
  
  max.num <- max(data.in.question$PRCP, na.rm = TRUE)
  break.point <- ((max - min) / 5)
  first.point <- min + break.point
  breaks <- seq(first.point, max, break.point)
  #breaks <- c(first.point, first.point + break.point, first.point + break.point * 2, first.point + break.point * 3, max)
  
  determine.break <- function(prcp) {
    point <- 0
    
    ifelse(prcp <= breaks[1], point <- paste0(min, " - ", breaks[1]), 
           ifelse(prcp <= breaks[2], point <- paste0(breaks[1], " - ", breaks[2]),
                  ifelse(prcp <= breaks[3], point <- paste0(breaks[2], " - ", breaks[3]),
                         ifelse(prcp <= breaks[4], point <- paste0(breaks[3], " - ", breaks[4]),
                                ifelse(prcp <= breaks[5], point <- paste0(breaks[4], " - ", breaks[5]), point <- 0)))))
  }
  
  data.in.question <- data.in.question %>% mutate(points = determine.break(data.in.question$PRCP)) %>% filter(!is.na(points))
  
  crime.color <- "white"
  if (violence == "Violent") {
    crime.color <- "red"
  } else if (violence == "Nonviolent") {
    crime.color <- "blue"
  } else {
    crime.color <- "purple"
  }
  
  
  data.in.question <- data.in.question %>% select(PRCP, !!avg.value, points)
  prcp.group <- group_by(data.in.question, points) %>% summarize(average = (sum(!!avg.value) / n()))
  la.bar <- ggplot(prcp.group) +
    geom_bar(mapping = aes(x = points, y = average), stat="identity", fill = crime.color) +
    geom_text(aes(x = points, y = average, label=round(average, digits = 2), vjust=-0.25)) +
    labs(title = paste0("Average Number of ", violence, " Crimes vs Precipitation Levels"),
         x = "Precipitation", 
         y = "Average number of crimes")
  
  
  return(la.bar)
}
