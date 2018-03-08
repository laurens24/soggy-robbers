library('shiny')
library('shinythemes')
library('leaflet')


my.ui <- navbarPage("Soggy Robbers",     #page title 
  theme = shinytheme("flatly"),
  #specific content for main home page 
  tabPanel("Home", 
           mainPanel(p(h3("Soggy Robbers")),
                     p("Stephen Moxley, Kara Lee, Lauren Smith and Michael Hart"), tags$br(),
                     tags$img(src='friends_umbrella.gif', width = 412, height = 232, 
                              style="display: block; margin-left: 100px; margin-right: 100px;"), 
                     p(h3("About Our Project")),
                     p("Soggy Robbers provide users with the proper data gathered from January 1st, 2016 to February 8th, 2018 to analyze trends and correlations between crime and
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
  #specific content for Boston
  tabPanel("Boston",
           sidebarLayout(         #layout page
             sidebarPanel(        #allows users to interact with the data by selecting specific filters 
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
                 #adds a bar chart 
                 tabPanel("Precipitation Chart",
                          plotOutput("Boston.bar"),
                          p("The bar chart above shows the average number of crimes corresponding to each range of precipitation
                            levels (in inches). The user can choose the crime type and the range of precipitation from the sidebar."),
                          p("In 2007, the state of Massachusetts passed legislation protecting the confidentiality of victims of 
                            rape and sexual assault, so none of the data relating to crimes in this category have been made available 
                            to the public. Therefore, the violent crimes for Boston may be skewed because the data is missing an 
                            entire category that is encompassed within the FBI definition of violent crimes."),
                          p(h4(strong("Correlation between precipitation levels and crime activity in Boston :"))),
                          p("There does not appear to be significant differences in different precipitation levels and average crime
                            activity in Boston. Average levels of precipitation are fairly stable across all crime types and
                            precipitation levels, and the range of crime both violent and nonviolent crime activity is 26.2 crimes, which
                            is not significant.")
                    ),
                 
                 #adds an interactive map that allows users to click on the map for more info 
                 tabPanel("Crime Map", leafletOutput("Boston.map"),
                          p("The map of Boston shows 200 randomly selected crimes based on the users filters."))
                 )
             
               )
             )
           ),
  #creates a tab for San Francisco
  tabPanel("San Francisco",
           sidebarLayout(    #layout page 
             sidebarPanel(    #adds interactive slider and radiobuttons
               sliderInput(
                 "precip.sf",
                 label = "Min/Max amount of precipitation",
                 value = c(0, 4.1),
                 min = 0,
                 max = 4.1
               ),
               radioButtons('violence.sf', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                               "Nonviolent" = "Nonviolent", 
                                                                               "Both" = "Violent and Nonviolent"))
             ),
             mainPanel(
               tabsetPanel(
                 #adds two tabs with a bar chart and an interactive map 
                 tabPanel("Precipitation Chart",
                          plotOutput("SF.bar"),
                          #adds descriptions about the chart 
                          p("The bar chart above shows the average number of crimes corresponding to each range of precipitation
                            levels (in inches). The user can choose the crime type and the range of precipitation from the sidebar."),
                          p(h4(strong("Correlation between precipitation levels and crime activity in San Francisco :"))),
                          p("There does not appear to be significant differences in different precipitation levels and average crime
                            activity in San Francisco. Average levels of precipitation are fairly stable across all crime types and
                            precipitation levels, and the range of crime both violent and nonviolent crime activity is 89.5 crimes, which
                            is not significant.")
                          ),
                 tabPanel("Crime Map", leafletOutput("SF.map"),
                          #adds an explanation of the map 
                          p("The map of San Francisco shows 200 randomly selected crimes based on the user's filters.")
                          )
               )
             )
           )),
  #cretes a tab for Los Angeles 
  tabPanel("Los Angeles", 
           sidebarLayout(      #layout page 
             sidebarPanel(      #creates an interactive slider and radiobuttons 
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
                 #adds two tabs with a bar chart and an interactive map 
                 tabPanel("Precipitation Chart",
                          plotOutput("LA.bar"),
                          #adds descriptions about the chart 
                          p("The bar chart above shows the average number of crimes corresponding to each range of precipitation
                                         levels (in inches). The user can choose the crime type and the range of precipitation from the sidebar. It should be noted that
                                         Los Angeles had 0 precipitation for 90% of the data gathered from January 1st, 2016 to February 8th, 2018.
                                         Since only 10% of the data corresponded to precipitation levels above 0, the results may not be the most accurate
                                         and cannot be used to imply causation"),


                          p(h4(strong("Correlation between precipitation levels and crime activity in Los Angeles:"))),

                          p("For Los Angeles, no correlation was found between precipitation and crime. The average number of crimes was the
                             lowest for the precipitation range of 0.9 to 1.2 for all crime types. The highest range of recipitation had the highest
                             average number of violent crimes. Los Angeles' overall average number of crime is 616.41 which is lower than the average
                             for the precipation range of 1.2 - 1.5 and very close to the range of 0 - 0.3. For violent crimes with the max set at 1.23, 
                             the average number of crimes seems to decrease as the level of precipitation increases. However, this seems to be the case 
                             only when the max is set at 1.23 or higher. For non-violent crimes, no clear trend was found.")),
                 tabPanel("Crime Map", leafletOutput("LA.map"),
                          #adds a short description of the map 
                          p("The map of Los Angeles above shows locations of 200 randomly selected crimes. Click on dots to find out more information about the specific crimes."))

               )
             )
           )),
  #creates a tab for Chicago 
  tabPanel("Chicago",
           sidebarLayout(     #layout page 
             sidebarPanel(     #adds an interactive slide bar and radiobuttons 
               sliderInput(
                 "precip.c",
                 label = "Min/Max amount of precipitation",
                 value = c(0, 5.1),
                 min = 0,
                 max = 5.1
               ),
               radioButtons('violence.c', label = "Crimes Included", choices = c("Violent" = "Violent", 
                                                                               "Nonviolent" = "Nonviolent", 
                                                                               "Both" = "Violent and Nonviolent"))
             ),
             #creates two tabs with a bar chart an interactive map
             mainPanel(
               tabsetPanel(
                 tabPanel("Precipitation Chart",
                          plotOutput("Chicago.bar"),
                          #adds descriptions for the chart
                          p("The bar chart above shows the average number of crimes corresponding to each range of precipitation
                            levels (in inches). The user can choose the crime type and the range of precipitation from the sidebar.
                            It should be noted that there was only 1 day in which Chicago received more than 4 inches of precipitation,
                            so there may be an innacurate representation of average crime at that precipitation level."),
                          p(h4(strong("Correlation between precipitation levels and crime activity in Chicago :"))),
                          p("There does appear to be significant differences in different precipitation levels and average crime
                            activity in Chicago, but this is mostly due to the outlier above 4 inches of precipitation. 
                            Without the outlier, average levels of precipitation are fairly stable across all crime types and
                            precipitation levels. The range of crimes with the outlier is 172.5 crimes, but it is much lower without
                            this observation.")
                          ),
                 tabPanel("Crime Map", leafletOutput("Chicago.map"),
                          #adds a short explanation of the map 
                          p("The map of Chicago shows 200 randomly selected crimes based on the users filters.")
                 )
               )
             )
           )),
  #creates a conclusion tab 
  tabPanel("Conclusion",
           mainPanel(
             #adds a summary of the data analysis 
             h1("Cross-City Analysis"),
             tags$hr(),
             h3("Precipitation and Crime"),
             p("Looking at average crime levels in each city showed that there is not significant
               variation in crime levels when precipitation occurs. The variation in average crime activity 
               for both violent and nonviolent crimes across varying precipitation levels is as 
               follows:"),
             tags$ul(
               tags$li("Boston - 26.2 Crimes"),
               tags$li("San Francisco - 89.5 crimes"),
               tags$li("Los Angeles - 117.83 crimes"),
               tags$li("Chicago - 172.5 crimes")
             ),
             p("While it may seem as though Chicago and Los Angeles exhibit large varation in crime
               activity based on precipitation, it is worth noting that Los Angeles had very few days with
               more than 1.12 inches of precipitation, and Chicago only had one day with more than 4 inches
               of precipitation. This causes the average calculations for those precipitation levels to vary
               significantly from the rest of the data. Without looking at those precipitation levels,
               Chicago and Los Angeles show variation that is more similar to the low values of Boston and
               San Francisco. Thus, we can conclude that precipitation levels do not have a significant impact
               on crime levels."),
             h3("Violence vs. Nonviolence"),
             p("When we compared average number of violent and nonviolent crimes for varying precipitation levels,
               the resulting bar graphs showed similar trends, if not the exact same trends. This led us to conclude
               that precipitation did not have a significant effect on whether violent or nonviolent crimes occurred.
               However, we could conclude that Chicago and Los Angeles exhibited the highest number of crimes,
               both violent and non-violent, with Chicago winning gold. It should be noted that this can be attributed
               to populations of each city. Boston's population 670,000 people and San Francisco's is 860,000 people, whereas
               Chicago's is 2.7 million people, and Los Angeles's is 3.9 million people."),
             h1("Overall Conclusion"),
             tags$hr(),
             p("Our results did not show any significant change in violent and nonviolent crimes for varying precipitation
               levels. Based on these conclusions, we urge individuals to be safe in all weather, not just sunny weather."),
             p("Thanks for visiting our project!")
           ))
)

