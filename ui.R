library('shiny')
library('shinythemes')
library('leaflet')

my.ui <- navbarPage("Put Title Here",
  theme = shinytheme("flatly"),
  tabPanel("Home", 
           mainPanel(p(h3("About Our Project")),
                     p("Soggy Robbers provide users with the proper data to analyze trends and correlations between crime and
                       precipitation in 4 cities - Boston, San Francisco, Los Angeles and Chicago."),
                     p("Questions we tried to answer through our data analysis :"),
                     p("1. Is there a correlation between precipitation levels and crime activity in Boston, San Francisco, Los Angeles and Chicago?"),
                     p("2. Is there a trend that emerges when looking at only violent or non-violent crimes?"),
                     p(h3("Datasets")),
                     p("All datasets used for analysis can be accessed here :"),
                     p(a("Weather datasets", href = 'https://www.climate.gov/maps-data/dataset/daily-temperature-and-precipitation-reports-data-tables')),
                     p(a("Boston crime dataset", href = 'https://data.boston.gov/dataset/crime-incident-reports-august-2015-to-date-source-new-system/resource/12cb3883-56f5-47de-afa5-3b1cf61b257b')),
                     p(a("San Francisco crime dataset", href = 'https://data.sfgov.org/Public-Safety/Police-Department-Incidents/tmnf-yvry')),
                     p(a("Los Angeles crime dataset", href = 'https://data.lacity.org/A-Safe-City/Crime-Data-from-2010-to-Present/y8tr-7khq')),
                     p(a("Chicago crime dataset", href = 'https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present-Dashboard/5cd6-ry5g'))
  )),
  tabPanel("Boston",
           sidebarLayout(
             sidebarPanel(
               sliderInput(
                 "precip.b",
                 label = "Min/Max amount of precipitation",
                 value = c(0, 1.5),
                 min = 0,
                 max = 1.5
               ),
               radioButtons('violence.b', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                               "Nonviolent" = "Nonviolent", 
                                                                               "Both" = "Violent and Nonviolent"))
               ),
             mainPanel(
               tabsetPanel(
                 tabPanel("Precipitation Chart",
                          plotOutput("Boston.bar")),
                 tabPanel("Crime Map", leafletOutput("Boston.map"))
               )
             )
           )),
  
  tabPanel("San Francisco",
           sidebarLayout(
             sidebarPanel(
               sliderInput(
                 "precip.sf",
                 label = "Min/Max amount of precipitation",
                 value = c(0, 4),
                 min = 0,
                 max = 4
               ),
               radioButtons('violence.sf', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                               "Nonviolent" = "Nonviolent", 
                                                                               "Both" = "Violent and Nonviolent"))
             ),
             mainPanel(
               tabsetPanel(
                 tabPanel("Precipitation Chart",
                          plotOutput("SF.bar")),
                 tabPanel("Crime Map", leafletOutput("SF.map"))
               )
             )
           )),
  tabPanel("Los Angeles",
           sidebarLayout(
             sidebarPanel(
               sliderInput(
                 "precip.la",
                 label = "Min/Max amount of precipitation",
                 value = c(0, 1.4),
                 min = 0,
                 max = 1.4
               ),
               radioButtons('violence.la', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                               "Nonviolent" = "Nonviolent", 
                                                                               "Both" = "Violent and Nonviolent"))
             ),
             mainPanel(
               tabsetPanel(
                 tabPanel("Precipitation Chart",
                          plotOutput("LA.bar")),
                 tabPanel("Crime Map", leafletOutput("LA.map"))
               )
             )
           )),
  tabPanel("Chicago",
           sidebarLayout(
             sidebarPanel(
               sliderInput(
                 "precip.c",
                 label = "Min/Max amount of precipitation",
                 value = c(0, 5),
                 min = 0,
                 max = 5
               ),
               radioButtons('violence.c', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                               "Nonviolent" = "Nonviolent", 
                                                                               "Both" = "Violent and Nonviolent"))
             ),
             mainPanel(
               tabsetPanel(
                 tabPanel("Precipitation Chart",
                          plotOutput("Chicago.bar")),
                 tabPanel("Crime Map", leafletOutput("Chicago.map"))
               )
             )
           ))
)

