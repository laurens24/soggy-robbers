source("setup.R")

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
  
  ############# CHICAGO ############
  ch.crime <- read_feather("data/chicago_crime.feather")

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
