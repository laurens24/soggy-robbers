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
                              tabPanel("Precipitation Chart", plotOutput("LA.bar")),
                              tabPanel("Crime Map", plotOutput("LA.map"))
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




