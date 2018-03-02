library('shiny')

ui <- fluidPage(
  titlePanel('Creative Title'),
  sidebarLayout(
    sidebarPanel(
      sliderInput('max.precip', label = "Max amount of precipitation", 
                  min = 0, max = 5, value = 5),
      selectInput('violence', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                     "Nonviolent" = "Nonviolent"), 
                  multiple = TRUE, selected = c("Violent", "Nonviolent"))
    ),
    mainPanel(
      tabsetPanel( type = "tabs",
                   tabPanel("Home"),
                   tabPanel("Boston", plotOutput("Boston.bar"), plotOutput("Boston.map")), 
                   tabPanel("San Francisco", plotOutput("SF.bar"), plotOutput("SF.map")), 
                   tabPanel("Los Angeles", plotOut("LA.bar"), plotOutput("LA.bar")),
                   tabPanel("Chicago", plotOutput("Chicago.bar"), plotOutput("Chicago.map"))
      )
    )
  )
)


