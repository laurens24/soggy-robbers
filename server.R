library(shiny)
library(ggplot2)
library(dplyr)

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
  return (input$precip[2])
})

min.precip <- reactive ({
  return (input$precip[1])
})

############### BOSTON #################
  
############## SAN FRAN ###############

############# LA #################

crime <- read.csv("data/los_angeles_crime.csv", stringsAsFactors = FALSE)
weather <- read.csv("data/LAsantamonica_weather.csv", stringsAsFactors = FALSE)
weather <- filter(weather, !is.na(PRCP))

avg.violent <- filter(crime, Violent == TRUE) %>% group_by(Date) %>% summarize(total = n())
colnames(avg.violent) <- c("Date", "Violent.total")

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



shinyServer(my.server)
