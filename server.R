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
  
  boston.crime <- read.csv("data/Boston_Crime_Data.csv", stringsAsFactors = FALSE)
  boston.crime$lat <- sapply(boston.crime$Location, GetX)
  boston.crime$long <- sapply(boston.crime$Location, GetY)
  
  boston.weather <- all.weather %>% filter(STATION == "US1MASF0001")
  boston.crime.with.weather <- left_join(boston.crime, boston.weather, by=c("Date" = "DATE")) %>% 
    distinct(ID, .keep_all = TRUE)
  boston.weather <- boston.weather[, 1:4]
  boston.weather <- boston.weather %>% filter(!is.na(PRCP))
  
  output$Boston.bar <- renderPlot({
    return(GetBar(boston.crime, boston.weather, max.precip(), min.precip(), violence()))
  })
  
  output$Boston.map <- renderLeaflet({
    return(GetMap(boston.crime.with.weather, violence(), max.precip(), min.precip(), -71.06, 42.36))
  })
  
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
  
  output$SF.map <- renderLeaflet({
    return(GetMap(sf.crime.with.weather, violence(), max.precip(), min.precip(), -122.42, 37.78))
  })
 
  ############# LA #################
  la.crime <- read.csv("data/los_angeles_crime.csv", stringsAsFactors = FALSE)
  la.crime <- filter(la.crime, Date <= as.Date("02/08/2018", format="%m/%d/%Y"))
  la.weather <- read.csv("data/LAsantamonica_weather.csv", stringsAsFactors = FALSE)
  la.weather <- filter(la.weather, !is.na(PRCP))
  
  output$LA.bar <- renderPlot({
    GetBar(la.crime, la.weather, max.precip(), min.precip(), violence())
  })
  
  la2.crime <- read.csv("data/los_angeles_crime.csv", stringsAsFactors = FALSE)
  la2.crime$lat <- sapply(la2.crime$Location, GetX)
  la2.crime$long <- sapply(la2.crime$Location, GetY)
  
  output$LA.map <- renderLeaflet({
    
    violence <- violence()
    max.precip <- max.precip()
    min.precip <- min.precip()
    
    la2.crime <- left_join(la2.crime, la.weather, by= c("Date"="DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    return(GetMap(la2.crime, violence, max.precip, min.precip, -118.2437, 34.0522))
    
  })

  ############# CHICAGO ############
  ch.crime <- read_feather("data/Chicago_Crime.feather")
  ch.crime$lat <- ch.crime$Lat
  ch.crime$long <- ch.crime$Long

  ch.weather <- all.weather %>% 
                filter(NAME == "CHICAGO 4.7 NE, IL US")
  
  ch.weather <- ch.weather[, 1:4]
  ch.weather$DATE <- as.Date(ch.weather$DATE)
  
  output$Chicago.bar <- renderPlot({
    return(GetBar(ch.crime, ch.weather, max.precip(), min.precip(), violence()))
  })

  output$Chicago.map <- renderLeaflet({
    
    violence <- violence()
    max.precip <- max.precip()
    min.precip <- min.precip()
    
    ch.crime <- left_join(ch.crime, ch.weather, by=c("Date" = "DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    return(GetMap(ch.crime, violence, max.precip, min.precip, -87.6298, 41.8781))
    
  })
}
