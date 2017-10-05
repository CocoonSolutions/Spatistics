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

shinyUI(
  fluidPage(
    theme = "bootstrap_custom.css",
    includeScript("gomap.js"),
    
    # 1 ---
    fluidRow(shiny::column(
      width = 12
      ,
      img(
        src = "Untitled-3.jpg",
        height = "100%",
        width = "100%"
      )
      
    )),
    
    # 2 ---
    fluidRow(
      shiny::column(width = 3),
      
      # 2.1 ---
      shiny::column(
        width = 6,
        h1("Geographic analysis and insights into Mariculture"),
        h4(
          "In 2014, ",
          span(
            "world per capita fish supply reached a new record high of 20 kg",
            style = "color:#7cb5ec"
          ),
          ". Aquaculture remains an important source of food, nutrition, income and livelihoods for hundreds of millions of people around the world. As fish is ",
          span("one of the most-traded food", style = "color:#7cb5ec"),
          " commodities worldwide with more than half of fish exports by value originating in developing countries, this fact raises a number of questions about the aquaculture industry in general."
        ),
        p(),
        h4(
          "Which countries import the largest amounts of fish? What are the processing steps of a saltwater fish company from production to sale? Which sizes and categories are in high demand? In which months the fish is sold with the higher price? What is the prediction for the future production and sales?"
        ),
        p(),
        h4(
          "This report intends to answer these questions using a detailed analysis based on data from a Major European Company Group*."
        ),
        # 2.1.1 ---
        # ----------------------------------------
        # Point 1 --------------------------------
        # ----------------------------------------
        fluidRow(shiny::column(
          width = 12,
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("1 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "An introduction to Company's production line and products"
          )
        )),
        fluidRow(
          shiny::column(
            width = 4,
            h4(
              "The production is separated in two main production lines: ",
              span("the Fresh and the Frozen fish.", style = "color:#7cb5ec"),
              " At the first step of the process, when the fish reach the appropriate sizes, they are taken to be processed. Then, the fish are separated in three categories: (a) Gutted, (b) Fillet and (c) Whole. The company produces ",
              span("4 types of fish and 17 distinct sizes", style = "color:#7cb5ec"),
              " in total."
            )
          ),
          shiny::column(
            width = 8,
            tabPanel(
              "Force Network",
              forceNetworkOutput("force", width = "100%", height = "200px")
            ),
            h4(tags$ul(
              tags$li("Product Line: Fresh and Frozen fish."),
              tags$li("Product Category: Gutted, Fillet and Whole"),
              tags$li("Product Name: Red Seabream, Seabass, Seabream and Meagre."),
              tags$li("Product Size: 0-200,	200-300, 300-400,	300-600 etc.")
            ))
          ),
          shiny::column(
            width = 12,
            h4(
              "Finally, according to the production line that are going follow, fish are packed and prepared for dispatch. The diagram describes the possible paths of every fish based on its size and type (Product Name)."
            )
          )
        ),
        # ----------------------------------------
        # Point 2 --------------------------------
        # ----------------------------------------
        fluidRow(shiny::column(
          width = 12,
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("2 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "What percentage of total sales is derived from exports?"
          )
        )),
        fluidRow(
          shiny::column(width = 4,
                        p(
                          h4(
                            "The total quantity of sales for the period of study is equal to 129,231.296 tonnes of fish. Only a share of 12.2% of this quantity is sold domestically. The rest is exported to 37 countries all over the world. Therefore, ",
                            span("90% of total sales is derived from exports. ", style = "color:#7cb5ec;"),
                            "The largest importers by volume are the countries of Italy, France, Portugal and Spain."
                          )
                        )),
          shiny::column(
            width = 8,
            highchartOutput("highchart2", width = "100%", height = "300px")
          )
        ),
        fluidRow(shiny::column(
          width = 12,
          p(
            h4(
              "The selling price depends on the type, the size, the product line meaning whether it is processed, the consignor country and the date of order."
            )
          ),
          h4(
            "In 2014, the company produced a quantity of ",
            span("25,890 tonnes", style = "color:#7cb5ec"),
            " of fish. According to a recent study** undertaken by FAO, this quantity represents ",
            span("~0.032%", style = "color:#7cb5ec"),
            " of total global capture production in marine waters for 2014 (81.5 million tonnes)."
          )
        )),
        # ----------------------------------------
        # Point 3 --------------------------------
        # ----------------------------------------
        fluidRow(shiny::column(
          width = 12,
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("3 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "High sales figures are depicted between May and September"
          ),
          h4(
            "Sales between ",
            span(
              "May and September reach an average of 44.62% of the total anual sales",
              style = "color:#7cb5ec"
            ),
            ". July is the month with the largest number of sales with an average of 14 millions while in February sales are in their lowest point with an average of 10.460 millions. Moreover, ",
            span("in July the company produces the largest quantity", style = "color:#7cb5ec"),
            ", almost an average of 2,500 tonnes. The month with the lowest amount of volume is February. The average quantity of production in February is 1,924 tonnes."
          ),
          highchartOutput("highchart3", width = "100%", height = "300px"),
          
          h4(
            "In July of 2016 the total sales of the ",
            span("company reached the number of 15,738€ millions ", style = "color:#7cb5ec"),
            ". This was the largest number in sales per month, from January of 2013 until August of 2017, although the maximun average price per month is depicted in May."
          )
        )),
        # ----------------------------------------
        # Point 4 --------------------------------
        # ----------------------------------------
        fluidRow(shiny::column(
          width = 12,
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("4 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "Demand for small sizes is greater than larger sizes"
          ),
          h4(
            "According to the analysis, smaller sizes are selling more than larger ones. In addition, ",
            span(
              "2 out of the 17 total sizes are the holders of 73.3% of total sales ",
              style = "color:#7cb5ec"
            ),
            " between January of 2013 and December of 2016. These sizes are (300-400) and (400-600). In the third place with 10.2% of total sales is the size of (600-800) and in the forth place with 6.9% is the size of (200-300) with 6.9%, which is also one one the smaller group of sizes."
          ),
          highchartOutput("hcontainer", height = "300px"),
          br()
          
        )),
        fluidRow(shiny::column(
          width = 12,
          
          fluidRow(
            shiny::column(
              width = 4,
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
              width = 4,
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
              width = 4,
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
        ))
        ,
        p(
          h4(
            "The total sales for ",
            span("size (400-600) increased in every year ", style = "color:#7cb5ec"),
            " for the study period, starting from 63.540€ millions and ending up to 77.708€ millions, which lead to an incerase of ~ 22%."
          )
        ),
        # ----------------------------------------
        # Point 5 --------------------------------
        # ----------------------------------------
        fluidRow(shiny::column(
          width = 12,
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("5 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "In 2015 Seabream had a raise of ~ 7 billion € in sales"
          ),
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          ),
          highchartOutput("highchart5", width = "100%", height = "400px"),
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )
        )),
        # ----------------------------------------
        # Point 6 --------------------------------
        # ----------------------------------------
        fluidRow(shiny::column(
          width = 12,
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("6 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "Price category: Whole vs Fillet vs Gutted"
          )
          ,
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )
          ,
          highchartOutput("highchart6", width = "100%", height = "400px"),
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )
        )),
        # ----------------------------------------
        # Point 7 --------------------------------
        # ----------------------------------------
        fluidRow(
          shiny::column(
            width = 12,
            h2(
              span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
              span("7 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
              span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
              span("-", style = "color:white; font-size: 120%;"),
              "Geographic destination of sales: clustering countries"
            )
            ,
            h4(
              "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            ),
            highchartOutput("highchart71", width = "100%", height = "400px"),
            h4(
              "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
            ),
            highchartOutput("highchart72", width = "100%", height = "400px")
          )
        ),
        # ----------------------------------------
        # Point 8 --------------------------------
        # ----------------------------------------
        fluidRow(
          shiny::column(
            width = 12,
            h2(
              span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
              span("8 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
              span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
              span("-", style = "color:white; font-size: 120%;"),
              "Mapping and classification analysis of destinations"
            ),
            h4(
              "66% of total sales came from 13,5% of countries. map etc, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            ),
            leafletOutput("map", "100%", "400px"),
            br()
            ,
            fluidRow(shiny::column(
              width = 12,
              fluidRow(
                shiny::column(width = 6,
                              selectInput("color", "Color", vars, selected = "cnt")),
                shiny::column(width = 6,
                              selectInput("size", "Size", vars, selected = "sales_c"))
              )
            )),
            fluidRow(
              shiny::column(
                width = 12,
                conditionalPanel(
                  "input.color == 'cumulfreqnum'",
                  # Only prompt for threshold when coloring or sizing by sales_q
                  numericInput("threshold", "Cumulative Sales threshold", 50)
                ),
                plotOutput("histCentile", height = 200),
                h4(
                  "66% of total sales came from 13,5% of countries. map etc, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                ),
                plotOutput("scatterCollegeIncome", height = 250),
                h4(
                  "3Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                )
              )
            )
          )
        ),
        # ----------------------------------------
        # Point 9 --------------------------------
        # ----------------------------------------
        fluidRow(shiny::column(
          width = 12,
          h2(
            span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("9 ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
            span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
            span("-", style = "color:white; font-size: 120%;"),
            "Sales forecast for 2018"
          ),
          h4(
            "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          ),
          highchartOutput("highchartforecast", width = "100%", height = "400px")
        )),
        # ----------------------------------------
        # Conclusion -----------------------------
        # ----------------------------------------
        fluidRow(
          shiny::column(
            width = 12,
            h2(
              span(". ", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
              span("> ", style = "background-color:#66a3ff; font-size: 120%; color:#ffffff;"),
              span(".", style = "background-color:#66a3ff; color:#66a3ff; font-size: 120%;"),
              span("-", style = "color:white; font-size: 120%;"),
              "Aquaculture is a dynamic industry with potentials in technology..."
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
            ),
            hr(),
            p(
              h5(
                "*The data have been collected from an Aquaculture Company Group located in Greece and refer to information about the orders of the company, amount of sale and quantity of fish, in the period between 1.1.2013 and 22.8.2017. Latest update: 24.9.2017"
              )
            ),
            p(
              h5(
                "**FAO, (2016). The State of World Fisheries and Aquaculture 2016, FAO.Contributing to food security and nutrition for all. Rome, 200 pp."
              )
            )
          )
        )
      ),
      shiny::column(width = 3)
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
  )
)