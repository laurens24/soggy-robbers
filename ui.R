library('shiny')

ui <- fluidPage(
  titlePanel('Creative Title'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('precip', label = "Max amount of precipitation", 
                  min = 0, max = 5, value = c(0, 5)), 
      radioButtons('violence', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                     "Nonviolent" = "Nonviolent", 
                                                                     "Both" = "Both")
                  )
    ),
    mainPanel(
      tabsetPanel( type = "tabs",
                   tabPanel("Home"),
                   tabPanel("Boston", plotOutput("Boston.bar"), plotOutput("Boston.map")), 
                   tabPanel("San Francisco", plotOutput("SF.bar"), plotOutput("SF.map")), 
                   tabPanel("Los Angeles", plotOutput("LA.bar", click = 'bar.click'), plotOutput("LA.map")),
                   tabPanel("Chicago", plotOutput("Chicago.bar"), plotOutput("Chicago.map"))
      )
    )
  )
)


