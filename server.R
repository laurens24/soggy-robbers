my.server <- function(input, output) {
  
  violence <- reactive ({
    violence <- c(input$violence.b, input$violence.sf, input$violence.la, input$violence.c)
    return (violence)
  })
  
  max.precip <- reactive ({
    precip <- c(input$precip.b[2], input$precip.sf[2], input$precip.la[2], input$precip.c[2])
    return (precip)
  })
  
  min.precip <- reactive({
    precip <- c(input$precip.b[1], input$precip.sf[1], input$precip.la[1], input$precip.c[1])
    return (precip)
  })

  all.weather <- read.csv("data/othercities_weather.csv", stringsAsFactors = FALSE)
    
  ############### BOSTON #################
  
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
    return(GetBar(san.fran.crime, sf.weather, max.precip()[2], min.precip()[2], violence()[2]))
  })
  
  output$SF.map <- renderLeaflet({
    return(GetMap(sf.crime.with.weather, violence()[2], max.precip()[2], min.precip()[2], -122.42, 37.78, 12))
  })
 
  ############# LA #################
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
  ch.crime <- read_feather("data/Chicago_Crime.feather")

  ch.weather <- read_feather("data/Chicago_Weather.feather")
  
  output$Chicago.bar <- renderPlot({
    return(GetBar(ch.crime, ch.weather, max.precip()[4], min.precip()[4], violence()[4]))
  })

  output$Chicago.map <- renderLeaflet({
    
    ch.crime <- left_join(ch.crime, ch.weather, by=c("Date" = "DATE")) %>% 
      distinct(ID, .keep_all = TRUE)
    
    return(GetMap(ch.crime, violence()[4], max.precip()[4], min.precip()[4], -87.6298, 41.8781, 10))
    
  })
}
