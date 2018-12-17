source("setup.R")

station.names <- c("BOSTON 0.5 WSW, MA US",
                   "SAN FRANCISCO 1.1 SW, CA US",
                   "SANTA MONICA 1.3 NNE, CA US",
                   "CHICAGO 4.7 NE, IL US")

my.server <- function(input, output) {
  violence <- reactive ({
    violence <- c(input$violence.b, input$violence.sf, input$violence.la, input$violence.c)
    return (violence)
  })
  
  min.precip <- reactive({
    precip <- c(input$precip.b[1], input$precip.sf[1], input$precip.la[1], input$precip.c[1])
    return (precip)
  })
  
  max.precip <- reactive ({
    precip <- c(input$precip.b[2], input$precip.sf[2], input$precip.la[2], input$precip.c[2])
    return (precip)
  })

  all.weather <- read_feather("data/all_weather.feather")
  
  ############# BOSTON #################
  boston.crime <- read_feather("data/boston_crime.feather")
  
  boston.weather <- all.weather %>%
                    filter(Name == station.names[1])
  
  output$Boston.bar <- renderPlot({
    return(GetBar(boston.crime, boston.weather, max.precip()[1], min.precip()[1], violence()[1]))
  })
  
  output$Boston.map <- renderLeaflet({
    left_join(boston.crime, boston.weather, by = "Date") %>% 
      distinct(ID, .keep_all = TRUE) %>%
      GetMap(violence()[1], max.precip()[1], min.precip()[1], 
             -71.06, 42.36, 12) %>%
      return()
  })
  
  ############# SAN FRAN #################
  sf.crime <- read_feather("data/sf_crime.feather")
  
  sf.weather <- all.weather %>%
                filter(Name == station.names[2])
  
  output$SF.bar <- renderPlot({
    return(GetBar(sf.crime, sf.weather, max.precip()[2], min.precip()[2], violence()[2]))
  })
  
  output$SF.map <- renderLeaflet({
    left_join(sf.crime, sf.weather, by = "Date") %>% 
      distinct(ID, .keep_all = TRUE) %>%
      GetMap(violence()[2], max.precip()[2], min.precip()[2], 
             -122.42, 37.78, 12) %>%
      return()
  })
  
  ############# LA #################
  la.crime <- read_feather("data/la_crime.feather")
  
  la.weather <- all.weather %>%
                filter(Name == station.names[3])
  
  output$LA.bar <- renderPlot({
    return(GetBar(la.crime, la.weather, max.precip()[3], min.precip()[3], violence()[3]))
  })
  
  output$LA.map <- renderLeaflet({
    left_join(la.crime, la.weather, by = "Date") %>% 
      distinct(ID, .keep_all = TRUE) %>%
      GetMap(violence()[3], max.precip()[3], min.precip()[3], 
             -118.2437, 34.0522, 10) %>%
      return()
  })
  
  ############# CHICAGO ############
  ch.crime <- read_feather("data/chicago_crime.feather")

  ch.weather <- all.weather %>%
                filter(Name == station.names[4])
  
  output$Chicago.bar <- renderPlot({
    return(GetBar(ch.crime, ch.weather, max.precip()[4], min.precip()[4], violence()[4]))
  })

  output$Chicago.map <- renderLeaflet({
    left_join(ch.crime, ch.weather, by = "Date") %>% 
      distinct(ID, .keep_all = TRUE) %>%
      GetMap(violence()[4], max.precip()[4], min.precip()[4], 
             -87.6298, 41.8781, 10) %>%
      return()
  })
}
