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
  crime <- read.csv("data/los_angeles_crime.csv", stringsAsFactors = FALSE)
  weather <- read.csv("data/LAsantamonica_weather.csv", stringsAsFactors = FALSE)
  weather <- filter(weather, !is.na(PRCP))
  
  avg.violent <- filter(crime, Violent == TRUE) %>% group_by(Date) %>% summarize(total = n())
  avg.violent <- avg.violent[c(1:770), ]
  
  avg.v.num <- sum(avg.violent$total) / nrow(avg.violent)
  colnames(avg.violent) <- c("Date", "Violent.total")
  
  avg.nonviolent <- filter(crime, Violent == FALSE) %>% group_by(Date) %>% summarize(total = n())
  avg.nonviolent <- avg.nonviolent[c(1:770), ]
  
  avg.nv.num <- sum(avg.nonviolent$total) / nrow(avg.nonviolent)
  colnames(avg.nonviolent) <- c("Date", "Nonviolent.total")
  
  avg.both <- group_by(crime, Date) %>% summarize(total = n())
  avg.both <- avg.both[c(1:770), ]
  
  avg.b.num <- sum(avg.both$total) / nrow(avg.both)
  colnames(avg.both) <- c("Date", "Both.total")
  
  colnames(weather) <- c("Station", "Name", "Date", "PRCP")
  
  combined.data <- left_join(crime, weather, by = "Date") %>% left_join(avg.violent, by = "Date") %>% left_join(avg.nonviolent, by = "Date") %>% left_join(avg.both, by = "Date")
  
  
  
  output$LA.bar <- renderPlot({
    avg.value = "0"
    if (violence() == "Violent") {
      avg.value <- "Violent.total" %>% rlang::sym()
    } else if (violence() == "Nonviolent") {
      avg.value <- "Nonviolent.total" %>% rlang::sym()
    } else {
      avg.value <- "Both.total" %>% rlang::sym()
    }
    
    max.num <- max(combined.data$PRCP, na.rm = TRUE)
    break.point <- ((max.precip() - min.precip()) / 5)
    first.point <- min.precip() + break.point
    breaks <- c(first.point, first.point + break.point, first.point + break.point * 2, first.point + break.point * 3, max.precip())
    
    determine.break <- function(prcp) {
      point <- 0
      
      ifelse(prcp <= breaks[1], point <- paste0(min.precip(), " - ", breaks[1]), 
             ifelse(prcp <= breaks[2], point <- paste0(breaks[1], " - ", breaks[2]),
                    ifelse(prcp <= breaks[3], point <- paste0(breaks[2], " - ", breaks[3]),
                           ifelse(prcp <= breaks[4], point <- paste0(breaks[3], " - ", breaks[4]),
                                  ifelse(prcp <= breaks[5], point <- paste0(breaks[4], " - ", breaks[5]), point <- 0)))))
    }
    
    #combined.data <- combined.data %>% select(Violent, PRCP, !!avg.value)
    combined.data <- combined.data %>% mutate(points = determine.break(combined.data$PRCP)) %>% filter(!is.na(points))
    
    crime.color <- "white"
    if (violence() == "Violent") {
      crime.color <- "red"
    } else if (violence() == "Nonviolent") {
      crime.color <- "blue"
    } else {
      crime.color <- "purple"
    }
    
    
    combined.data <- combined.data %>% select(Violent, PRCP, !!avg.value, points)
    prcp.group <- group_by(combined.data, points) %>% summarize(average = (sum(!!avg.value) / n()))
    la.bar <- ggplot(prcp.group) +
      geom_bar(mapping = aes(x = points, y = average), stat="identity", fill = crime.color) +
      geom_text(aes(x = points, y = average, label=round(average, digits = 2), vjust=-0.25)) +
      labs(title = paste0("Average Number of ", violence(), " Crimes vs Precipitation Levels"),
           x = "Precipitation", 
           y = "Average number of crimes")
    
    
    return(la.bar)
    
  })
  
  ############# CHICAGO ############
  
}
