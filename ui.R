library('shiny')
library('shinythemes')
library('leaflet')

my.ui <- navbarPage("Put Title Here",
  theme = shinytheme("flatly"),
  tabPanel("Home", 
           mainPanel(p(h3("Soggy Robbers")),
                     p("Stephen Moxley, Kara Lee, Lauren Smith and Michael Hart"), tags$br(),
                     p(h3("About Our Project")),
                     p("Soggy Robbers provide users with the proper data to analyze trends and correlations between crime and
                       precipitation in 4 cities - Boston, San Francisco, Los Angeles and Chicago."), tags$br(),
                     p(h4("Questions we tried to answer through our data analysis :")),
                     p("1. Is there a correlation between precipitation levels and crime activity in Boston, San Francisco, Los Angeles and Chicago?"),
                     p("2. Is there a trend that emerges when looking at only violent or non-violent crimes?"),
                     tags$br(),
                     p(h3("Use")),
                     p(h4("Precipitation Chart :")),
                     p("Using the sidebar on the left, users can select a range of precipitation levels and the crime type. The precipitation chart will 
                       compare the average daily number of crimes to different variations of precipitation levels."),
                     p(h4("Crime Map : ")),
                     p("Based on the choices the user selected from the sidebar, the map will show 200 randomly selected crimes that correspond to those 
                       selections. The user can click on the dots on the map for a short description of the specific crime. The user can also zoom out or in on
                       the map to get an overall view of popular crime locations in different cities. "),
                     tags$br(),
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
                          plotOutput("LA.bar"),
                          p("The bar chart above shows the average number of crimes corresponding to each range of precipitation
                                         levels (in inches). The user can choose the crime type and the range of precipitation from the sidebar. It should be noted that
                                         Los Angeles had 0 precipitation for 90% of the data gathered from January 1st, 2016 to February 8th, 2018.
                                         Since only 10% of the data corresponded to precipitation levels above 0, the results may not be the most accurate
                                         and cannot be used to imply causation"),
                          p(h4("Correlation between precipitation levels and crime activity :")),
                          p("For Los Angeles, no correlation was found between precipitation and crime. The average number of crimes was the
                                         lowest for the precipitation range of 0.9 to 1.2 for all crime types. The highest range of recipitation had the highest
                                         average number of violent crimes. Los Angeles' overall average number of crime is 616.41 which is lower than the average
                                         for the precipation range of 1.2 - 1.5 and very close to the range of 0 - 0.3."),
                          p(h4("Trends among violent or non-violent crimes :")),
                          p("There were no clear trends among violent or non-violent crimes. The highest range of precipitation had the highest number of 
                            crimes for both violent and non-violent crimes. For violent crimes with the max set at 1.23, the average number of crimes seems to decrease as the level of 
                            precipitation increases. However, this seems to be the case only when the max is set at 1.23 or higher. For non-violent crimes, no clear trend 
                            was found.")),
                 tabPanel("Crime Map", leafletOutput("LA.map"),
                          p("The map of Los Angeles above shows locations of 200 randomly selected crimes. Click on dots to find out more information about the specific crimes."))
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
           )),
  tabPanel("Conclusion",
           mainPanel(
             p("no correlation lol")
           ))
)

