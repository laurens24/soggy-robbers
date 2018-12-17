source("setup.R")
source("server.R")
source("ui.R")

# Creates the Shiny app
shinyApp(ui = my.ui, server = my.server)
