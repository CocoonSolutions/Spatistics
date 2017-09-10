# https://stackoverflow.com/questions/29423602/unused-argument-error-with-offset-in-column-for-shiny
library(shiny)

library(googleCharts)

## if (!require(devtools))
##   install.packages("devtools")
## devtools::install_github("jbkunst/highcharter")

library("leaflet")
library('networkD3')
library("highcharter")

# Choices for drop-downs
vars <- c(
  "Quantity" = "sales_q",
  "Sales Cumulative Freq" = "cumulfreqnum",
  "Sales" = "sales_c",
  "Total Number of Orders" = "cnt",
  "Population 2016" = "pop2016",
  "GDP 2016" = "gdp2016"
)

shinyUI(fluidPage(
  theme = "bootstrap.css",
  
  includeScript("gomap.js"),
  
  # 1 ---
  fluidRow(shiny::column(
    width = 12,
    img(
      src = "Untitled-3.jpg",
      height = "100%",
      width = "100%"
    )
    
  )),
  
  # 2 ---
  fluidRow(
    shiny::column(width = 1),
    
    # 2.1 ---
    shiny::column(
      width = 10,
      h2("This is the main tiltle of the story."),
      h4(
        "This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story."
      ),
      
      # 2.1.1 ---
      # ----------------------------------------
      # Point 1 --------------------------------
      # ----------------------------------------
      fluidRow(shiny::column(
        width = 12,
        tags$h1("_____________", style = "color:#66a3ff; text-align:center; font-size: 20px;"),
        h2(
          span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
          span("1 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
          span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
          span("-", style = "color:white; font-size: 120%;"),
          "This is the main tiltle of the paragraph."
        )
      )),
      fluidRow(
        shiny::column(
          width = 4,
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          ),
          h4(tags$ul(
            tags$li(
              "First list item First list item First list item First list item First list item"
            ),
            br(),
            tags$li(
              "Second list item First list item First list item First list item First list item First list item First list item First list item First list item First list item First list item"
            ),
            br(),
            tags$li("Third list item")
          ))
        ),
        shiny::column(
          width = 8,
          h4(
            "3Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          ),
          leafletOutput("map", "100%", "400px"),
          br(),
          fluidRow(
            shiny::column(
              width = 4,
              selectInput("color", "Color", vars, selected = "cnt"),
              selectInput("size", "Size", vars, selected = "sales_c"),
              conditionalPanel(
                "input.color == 'cumulfreqnum'",
                # Only prompt for threshold when coloring or sizing by sales_q
                numericInput("threshold", "Cumulative Sales threshold", 50)
              )
            ),
            shiny::column(width = 8,
                          plotOutput("histCentile", height = 200))
          ),
          shiny::column(width = 12,
                        plotOutput("scatterCollegeIncome", height = 250))
        )
      ),
      # ----------------------------------------
      # Point 2 --------------------------------
      # ----------------------------------------
      fluidRow(shiny::column(
        width = 12,
        tags$h1("_____________", style = "color:#66a3ff; text-align:center; font-size: 20px;"),
        h2(
          span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
          span("2 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
          span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
          span("-", style = "color:white; font-size: 120%;"),
          "This is the main tiltle of the paragraph."
        )
      )),
      fluidRow(
        shiny::column(
          width = 4,
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )
        ),
        shiny::column(
          width = 8,
          tabPanel(
            "Force Network",
            forceNetworkOutput("force", width = "100%", height = "200px")
          ),
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )
        )
      ),
      # ----------------------------------------
      # Point 3 --------------------------------
      # ----------------------------------------
      fluidRow(shiny::column(
        width = 12,
        tags$h1("_____________", style = "color:#66a3ff; text-align:center; font-size: 20px;"),
        h2(
          span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
          span("3 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
          span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
          span("-", style = "color:white; font-size: 120%;"),
          "This is the main tiltle of the paragraph."
        )
      )),
      fluidRow(
        shiny::column(
          width = 4,
          h4(
            "3Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )
        ),
        shiny::column(
          width = 8,
          h4(tags$ul(
            tags$li(
              "First list item First list item First list item First list item First list item"
            ),
            br(),
            tags$li(
              "Second list item First list item First list item First list item First list item First list item First list item First list item First list item First list item First list item"
            ),
            br(),
            tags$li("Third list item")
          )),
          h4(
            "3Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )
          ,
          highchartOutput("hcontainer", height = "500px"),
          br()
          ,
          fluidRow(
            shiny::column(
              width = 5,
              align = "center",
              sliderInput(
                "year",
                label = "Year",
                min = min(years),
                max = max(years),
                step = 1,
                sep = "",
                value = min(years),
                animate = animationOptions(interval = 2500, loop = TRUE)
              )
            ),
            shiny::column(
              width = 3,
              align = "center",
              selectInput(
                "plot_type",
                selected = "line",
                label = "Plot type",
                choices = c(
                  "Scatter" = "scatter",
                  "Bar" = "column",
                  "Line" = "line"
                )
              )
            ),
            shiny::column(
              width = 3,
              align = "center",
              selectInput(
                "metric",
                selected = "sales",
                label = "Metric",
                choices = c("Total sales" = "sales",
                            "Total quantity" = "quantity")
              )
            )
          )
        )
      ),
      # ----------------------------------------
      # Conclusion -----------------------------
      # ----------------------------------------
      fluidRow(
        shiny::column(
          width = 12,
          tags$h1("_____________", style = "color:#66a3ff; text-align:center; font-size: 20px;"),
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("> ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "This is the conclusion."
          ),
          p("p creates a paragraph of text."),
          p(
            "A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph."
          ),
          strong("strong() makes bold text."),
          em("em() creates italicized (i.e, emphasized) text."),
          br(),
          code("code displays your text similar to computer code"),
          div(
            "div creates segments of text with a similar style. This division of text is all #66a3ff because I passed the argument 'style = color:#66a3ff' to div",
            style = "color:#66a3ff"
          ),
          br(),
          p(
            "span does the same thing as div, but it works with",
            span("groups of words", style = "color:#66a3ff"),
            "that appear inside a paragraph."
          )
        )
      )
    ),
    shiny::column(width = 1)
  ),
  # 3 ---
  fluidRow(shiny::column(
    width = 12,
    img(
      src = "Untitled-4.jpg",
      height = "100%",
      width = "100%"
    )
  ))
))