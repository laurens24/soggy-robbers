my.ui <- fluidPage(
  theme = shinytheme("sandstone"),
  titlePanel('Creative Title'),
  sidebarLayout(
    sidebarPanel(
      uiOutput("slider"),
      radioButtons('violence', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                     "Nonviolent" = "Nonviolent", 
                                                                     "Both" = "Violent and Nonviolent")

                  )
    ),
    mainPanel(
      tabsetPanel( id = "tabpanel",
                   type = "tabs",
                   tabPanel("Home", 
                            p(h3("About Our Project")),
                            p("Soggy Robbers provides users with the proper data to analyze trends and correlations between crime and
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
                            p(a("Chicago crime dataset", href = 'https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present-Dashboard/5cd6-ry5g'))),
                   tabPanel("Boston",
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("Boston.bar")),
                              tabPanel("Crime Map", leafletOutput("Boston.map"))
                            )
                   ), 
                   tabPanel("San Francisco", 
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("SF.bar")),
                              tabPanel("Crime Map", leafletOutput("SF.map"))
                            )
                   ),
                   tabPanel("Los Angeles",
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("LA.bar"),
                                       p("The bar chart above shows the average number of crimes corresponding to each range of precipitation
                                         levels. The user can choose the crime type and the range of precipitation from the sidebar. It should be noted that
                                         Los Angeles had 0 precipitation for 90% of the data gathered from January 1st, 2016 to February 8th, 2018.
                                         Since only 10% of the data corresponded to precipitation levels above 0, the results may not be the most accurate
                                         and cannot be used to imply causation"),
                                       p(h3("Correlation between precipitation levels and crime activity :")),
                                       p("For Los Angeles, no correlation was found between precipitation and crime. The average number of crimes was the
                                         lowest for the precipitation range of 0.9 to 1.2 for all crime types. The highest range of recipitation had the highest
                                         average number of violent crimes. Los Angeles' overall average number of crime is 616.41 which is lower than the average
                                         for the precipation range of 1.2 - 1.5 and very close to the range of 0 - 0.3.")),
                              tabPanel("Crime Map", leafletOutput("LA.map"),
                                       p("The map of Los Angeles above shows locations of 200 randomly selected crimes."))
                            )
                   ),
                   tabPanel("Chicago",
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("Chicago.bar")),
                              tabPanel("Crime Map",
                                       leafletOutput("Chicago.map"),
                                       p("Here is a random sampling of the crimes from this area."), 
                                       p("Of the 566,783 total crimes between January 1st, 2016 and February 8th, 2018 only 200 are being displayed."))
                            ))
      )
    )
  )
)




