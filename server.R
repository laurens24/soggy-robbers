library(shiny)

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