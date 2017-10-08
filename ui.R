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
          ),
          h4(
            "The production is separated in two main production lines: ",
            span("the Fresh and the Frozen fish.", style = "color:#7cb5ec"),
            " At the first step of the process, when the fish reach the appropriate sizes, they are taken for further processing."
          )
        )),
        fluidRow(
          shiny::column(
            width = 4,
            h4(
              "Thus, the fish are separated in three categories: (a) Gutted, (b) Fillet and (c) Whole. Its category contains its products and every product its own sizes. Same products may exist in more than one categories."
            ),
            p(h4(
              "The company produces ",
              span("4 types of fish and 17 distinct sizes", style = "color:#7cb5ec"),
              " in total."
            ))
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
              "The selling price depends on the type, the size, the product line - meaning whether it is processed or not -, the consignor country and the date of order."
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
              "May and September reach an average of 44.62% of the total annual sales",
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
            ". This was the largest number in sales per month, from January of 2013 until August of 2017, although the maximum average price per month is depicted in May."
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
            span("2 out of 17 sizes are the holders of 73.3% of total sales ",
                 style = "color:#7cb5ec"),
            " between January of 2013 and December of 2016. These sizes are (300-400) and (400-600). In the third place with 10.2% of total sales is the size of (600-800) and in the forth place with 6.9% is the size of (200-300), which is also one of the smaller group of sizes."
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
            " for the study period, starting from 63.540€ millions and ending up to 77.708€ millions, which lead to an increase of ~ 22%."
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
            "In 2015, total production of Seabream was less than in previous years. However, in the same year, ",
            span(
              "the selling price of Seabream reached its maximum value with an average of 5.84€/kg.",
              style = "color:#7cb5ec"
            ),
            "Moreover, in July of 2015 the selling price was at its highest value between January 2013 and July. The top 5 average selling prices per month for Seabream where from May to September of 2015 (6.22€/kg). This indicates that the demand for Seabream is increasing over the years."
          ),
          highchartOutput("highchart5", width = "100%", height = "400px"),
          h4(
            "On the other hand, the selling price of Meagre has been decreasing over the last months. This confirms a previous conclusion that ",
            span("small sizes have a greater demand than larger ones", style = "color:#7cb5ec"),
            ", as sizes for Meagre range from (500-1000) to (4000+)."
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
            "According to the average selling price through the period of study, Fillet is sold 1.84 times more than Gutted and 2.45 times more than Whole fish. Despite the difference in the selling price among the three categories, Whole fish is the dominant category in sales as ",
            span(
              "almost 90% of total revenue is obtained from the sales of Whole fish.",
              style = "color:#7cb5ec"
            )
          )
          ,
          highchartOutput("highchart6", width = "100%", height = "400px"),
          h4(
            "Similar proportions are occurred also in quantities. 93.75% of total quantity produced follows the path of the Whole fish while only the 6% is sold in the market as Fillet or Gutted fish."
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
              "The company has 38 point of sales all over the world. Each point represents a country from Canada to Singapore. Top 10 countries in sales are Italy, France, Greece, Portugal, Spain, Great Britain, Germany, USA, Holland and Romania. Between the period from January of 2013 to December of 2017, these ",
              span(
                "10 countries held almost 90% of total sales (~535€ millions).",
                style = "color:#7cb5ec"
              )
            ),
            p(
              h4(
                "The total quantity produced for the same countries and period was 97,688 tonnes of fish that is equivalent to 89.49% of the total quantity."
              )
            ),
            highchartOutput("highchart71", width = "100%", height = "400px"),
            h4(
              "A cluster analysis of countries characteristics shows that Russia, although has a GDP close to Romania and population 8 times more than Romania's, it is grouped with countries with medium sales. A further analysis shows that in August of 2014 Russia stopped purchasing fish products from the company. One reason for this is that this might be caused by ",
              span(
                "Russia's embargo that banned European Union food imports in August of 2014.",
                style = "color:#7cb5ec"
              ),
            " And that is also the case with Ukraine."
          ),
          highchartOutput("highchart72", width = "100%", height = "400px"),
          h4(
            "Another conclusion from this cluster analysis is that although Greece, Portugal, Estonia and Czech Republic have great similarity in terms of GDP and total population, they are grouped in different clusters. Greece and Portugal belong to the first group whereas Estonia and Czech Republic belong to the second. This is also due to the fact that ",
              span(
                "Greece is where company's head office are located and Portugal has a very high rate in sales (4th place)",
                style = "color:#7cb5ec"
              ),
            " whereas sales figures for Estonia and Czech Republic show a discontinuous demand for fish."
          )
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
            "In 2016, 84% of the countries that had at least one trunsanction were European. Using the classification method of equal intervals with 7 classes, the map shows that in case of total quantity for year 2016, the 7th class contains 22 countries. That is also the case with total sales. This indicates that top countries in sales exceed by far countries with lower sales. The countries with the higher sales were Italy, France, Greece, Spain and Portugal. Actually, ",
              span(
                "~67% of total sales in 2016 came from 16% of total countries",
                style = "color:#7cb5ec"
              ),
            " or from 5 Mediterranean countries."
          ),
          leafletOutput("map", "100%", "400px"),
          br()
          ,
          fluidRow(shiny::column(
            width = 12,
            fluidRow(
              shiny::column(width = 6,
                            selectInput("color", "Color", vars, selected = "sales_c")),
              shiny::column(width = 6,
                            selectInput("size", "Size", vars, selected = "sales_q"))
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
                "Analyzing sales ",
              span(
                "from January 2013 to December 2016",
                style = "color:#7cb5ec"
              ),
            ", numbers showed that these ",
              span(
                "5 mediterranean countries",
                style = "color:#7cb5ec"
              ),
            ", which in this case represent 13,5% of total countries, ",
              span(
                "held 66% of total sales.",
                style = "color:#7cb5ec"
              )
              ),
              plotOutput("scatterCollegeIncome", height = 250),
              h4(
                "According to countries classification, the ",
              span(
                "top 5 countries belong to five different classes",
                style = "color:#7cb5ec"
              ),
            ". The scatter plot describes the reason of this result. The top 5 five countries on the upper right of the plot are shown to have larger distances among them whereas countries with lower sales and quantity are very close to each other and thus can be easily grouped together."
              ),
            p(h4("The cumulative frequency of sales, which is defined as the sum of all previous frequencies up to the current point, when frequencies are ordered from the smallest to the largest, indicates that ",
              span(
                "countries with lower sales have a small contribution in total sales.",
                style = "color:#7cb5ec"
              )))
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
          "Based on data from January 2013 to August 2017, the prediction of total sales per month for the next 12 months is very positive. Sales will have a constant decline until February of 2018 and after that they will increase and ",
              span(
                "in July of 2018 will reach the number of ~16.9 millions,",
                style = "color:#7cb5ec"
              ), " which is the highest value of total sales from January of 2013."
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
            "Conclusion"
          ),
          p(h4("The main conclusions of this analysis are briefly summarised below:")),
             h4(tags$ul(
              tags$li("Countries that import and consume the majority of these specific types of fish products are the ",
              span(
                "mediterranean countries",
                style = "color:#7cb5ec"
              ), "mediterranean countries (Italy, France, Greece, Spain and Portugal)."),
              tags$li("The consumers ",
              span(
                "prefer fish categories with smaller sizes",
                style = "color:#7cb5ec"
              ), " than categories with larger sizes."),
              tags$li("Selling prices are ",
              span(
                "higher during summer months",
                style = "color:#7cb5ec"
              ), ", especially in July."),
              tags$li("The ",
              span(
                "demand for Marineculture products will grow",
                style = "color:#7cb5ec"
              ), " in the near future.")
            )),
          p(h4("Global population is expected to reach ",
              span(
                "9.7 billion by 2050.",
                style = "color:#7cb5ec"
              ), " As far as the oceans and inland waters provide potentials to contribute ever more to food security and adequate nutrition for the global population, aquaculture will remain an important source in the future. Thus, in view of this analysis, Marineculture can be chacterized as a ",
              span(
                "dynamic growing sector that will contribute measurably",
                style = "color:#7cb5ec"
              ), " to the completion of the increasing demand for food in the next decades.")),
          tags$hr(),
          p(
            h5(
              "*The data have been collected from an Aquaculture Company Group located in Greece and refer to information about the orders of the company, amount of retail sales and quantity of fish, in the period between 1.1.2013 and 22.8.2017. Latest update: 24.9.2017"
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