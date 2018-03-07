library(shiny)
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

GetBar <- function(crime, weather, max, min, violence) {
  avg.violent <- filter(crime, Violent == TRUE) %>% group_by(Date) %>% summarize(Violent.total = n())
  
  avg.nonviolent <- filter(crime, Violent == FALSE) %>% group_by(Date) %>% summarize(Nonviolent.total = n())
  
  avg.both <- group_by(crime, Date) %>% summarize(Both.total = n())
  
  colnames(weather) <- c("Station", "Name", "Date", "PRCP")
  
  #combined.data <- left_join(crime, weather, by = "Date") %>% left_join(avg.violent, by = "Date") %>% left_join(avg.nonviolent, by = "Date") %>% left_join(avg.both, by = "Date")
  
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
  # breaks <- c(first.point, first.point + break.point, first.point + break.point * 2, first.point + break.point * 3, max)
  
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
  
  slider.max <- reactive({
    switch(input$tabpanel,
           "Home" = 1.5,
           "Boston" = 1.5,
           "San Francisco" = 4,
           "Los Angeles" = 1.5,
           "Chicago" = 5
    )
  })
  
  output$slider <- renderUI({
    print(slider.max())
    sliderInput(
      "precip",
      label = "Min/Max amount of precipitation",
      value = c(0, slider.max()),
      min = 0,
      max = slider.max()
    )
  })  


  all.weather <- read.csv("data/othercities_weather.csv", stringsAsFactors = FALSE)
    
  ############### BOSTON #################
  
  ############## SAN FRAN ###############
  # SF Data Manipulation
  
  san.fran.crime <- read.csv("data/san_francisco_crime.csv", stringsAsFactors = FALSE)
  san.fran.crime$lat <- sapply(san.fran.crime$Location, GetX)
  san.fran.crime$long <- sapply(san.fran.crime$Location, GetY)
  
  sf.weather <- all.weather %>% filter(STATION == "US1CASF0004")
  sf.crime.with.weather <- left_join(san.fran.crime, sf.weather, by=c("Date" = "DATE")) %>% 
    distinct(ID, .keep_all = TRUE)
  sf.weather <- sf.weather[, 1:4]
  sf.weather <- sf.weather %>% filter(!is.na(PRCP))
  
  output$SF.bar <- renderPlot({
    return(GetBar(san.fran.crime, sf.weather, max.precip(), min.precip(), violence()))
  })
  
  output$SF.map <- renderPlot({
    map <- get_map("san francisco, california", zoom = 12)
    return(GetMap(sf.crime.with.weather, violence(), max.precip(), min.precip(), map))
  })
 
  ############# LA #################
  la.crime <- read.csv("data/los_angeles_crime.csv", stringsAsFactors = FALSE)
  la.crime <- filter(la.crime, Date <= as.Date("02/08/2018", format="%m/%d/%Y"))
  la.weather <- read.csv("data/LAsantamonica_weather.csv", stringsAsFactors = FALSE)
  la.weather <- filter(la.weather, !is.na(PRCP))
  
  output$LA.bar <- renderPlot({
    GetBar(la.crime, la.weather, max.precip(), min.precip(), violence())
  })
  
  ############# CHICAGO ############
  
}
