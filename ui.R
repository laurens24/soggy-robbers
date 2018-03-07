library('shiny')

my.ui <- fluidPage(
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
                   tabPanel("Home"),
                   tabPanel("Boston",
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("Boston.bar")),
                              tabPanel("Crime Map", plotOutput("Boston.map"))
                            )
                   ), 
                   tabPanel("San Francisco", 
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("SF.bar")),
                              tabPanel("Crime Map", plotOutput("SF.map"))
                            )
                   ),
                   tabPanel("Los Angeles",
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("LA.bar"),
                                       p("The bar chart above shows the average number of crimes corresponding to each range of precipitation
                                         levels. The user can choose the crime type and the range of precipitation from the sidebar. It should be noted that
                                         Los Angeles had 0 precipitation for 90% of the data gathered from January 1st, 2016 to February 8th, 2018.
                                         Since only 10% of the data corresponded to precipitation levels above 0, the results may not be the most accurate
                                         and cannot be used to imply causation")),
                              tabPanel("Crime Map", plotOutput("LA.map"),
                                       p("The map of Los Angeles above shows locations of 200 randomly selected crimes."))
                            )
                   ),
                   tabPanel("Chicago",
                            tabsetPanel(
                              tabPanel("Precipitation Chart", plotOutput("Chicago.bar")),
                              tabPanel("Crime Map", plotOutput("Chicago.map"))
                            ))
      )
    )
  )
)




