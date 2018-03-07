library(shiny)
library(ggplot2)

# Input: A pre-joined dataframe of crime and weather, and an optional min 
#   and max
# Output: A dataframe of the crimes that have a precipitation level greater
#   than or equal to the given min (if one is given) and less than the given
#   max (if one is given)
makeBuckets <- function(data) {
  splitwidth <- max(data$PRCP) / 5

  data %>%
    mutate(bucket = PRCP %/% splitwidth)
}

##### CHICAGO #####
ch.crime.data <- read.csv("data/Chicago_Crime_Data.csv", 
                          stringsAsFactors=FALSE)

ch.crime.counted <- ch.crime.data %>%
                    group_by(Date, Violent) %>%
                    summarize(count = n())

ch.wthr.data <- read.csv("data/chicago_weather.csv", 
                            stringsAsFactors=FALSE)

ch.crime.wthr <- ch.crime.counted %>%
                 inner_join(ch.wthr.data, by=c("Date" = "DATE"))

### SERVER ###

my.server <- function(input, output) {
  
violence <- reactive ({
  return (input$violence)
})

max.precip <- reactive ({
  return (input$max.precip)
})


############### BOSTON #################
  
############## SAN FRAN ###############

############# LA #################

############# CHICAGO ############
}



shinyServer(my.server)
