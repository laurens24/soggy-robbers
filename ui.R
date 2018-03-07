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
                   tabPanel("Boston", plotOutput("Boston.bar"), plotOutput("Boston.map")), 
                   tabPanel("San Francisco", plotOutput("SF.bar"), plotOutput("SF.map")), 
                   tabPanel("Los Angeles", plotOutput("LA.bar", click = 'bar.click'), plotOutput("LA.map")),
                   tabPanel("Chicago", plotOutput("Chicago.bar"), plotOutput("Chicago.map"))
      )
    )
  )
)




