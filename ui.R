
shinyUI(fluidPage(theme = "bootstrap.css",
                  
  titlePanel("Story Telling Web App"),
  
    navbarPage("My Application",
      tabPanel("Component 1"),
      tabPanel("Component 2"),
      navbarMenu("More",
        tabPanel("Sub-Component A"),
        tabPanel("Sub-Component B"))
    )
))