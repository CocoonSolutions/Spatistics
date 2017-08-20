library(leaflet)

# --- new
# Choices for drop-downs
vars <- c(
  "Max Quantity" = "records",
  "Cumulative Frequency" = "cumulfreqnum",
  "Quantity" = "quantity",
  "Count of Records" = "cnt"
)
# --- new

fluidPage(theme = "bootstrap.css",
          
          # Include our custom CSS  and js ---
          tags$head(
            #includeCSS("styles.css"),
            includeScript("gomap.js")
          ),
          
          # 1 ---
          fluidRow(
            column(width = 12,
                   img(src="olives.jpg", height = "100%", width = "100%")
                   
            )
          ),
          
          # 2 ---
          fluidRow(
            column(width = 1
            ),
            
            # 2.1 ---
            column(width = 10,
                   h2("This is the main tiltle of the story."),
                   h4("This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story."),
                   
                   # 2.1.1 ---
                   # ----------------------------------------
                   # Point 1 --------------------------------
                   # ----------------------------------------
                   fluidRow(
                     column(width = 12,
                            tags$h1("_____________", style = "color:red; text-align:center; font-size: 20px;"),
                            h2(span(". ", style = "background-color:red; color:red; font-size: 120%;"),
                               span("1 ", style = "background-color:red; font-size: 120%;"),
                               span(".", style = "background-color:red; color:red; font-size: 120%;"),
                               span("-", style = "color:white; font-size: 120%;"),"This is the main tiltle of the paragraph.")
                     )
                   ),
                   fluidRow(
                     column(width = 4,
                            h4("2These changes have increased wealth inequality significantly. In 1963, families near the top had six times the wealth (or, $6 for every $1) of families in the middle. By 2013, they had 12 times the wealth of families in the middle."),
                            h4(tags$ul(
                              tags$li("First list item First list item First list item First list item First list item"), 
                              br(),
                              tags$li("Second list item First list item First list item First list item First list item First list item First list item First list item First list item First list item First list item"), 
                              br(),
                              tags$li("Third list item")
                            ))
                     ),
                     column(width = 8,
                            h4("3These changes have increased wealth inequality significantly. In 1963, families near the top had six times the wealth (or, $6 for every $1) of families in the middle. By 2013, they had 12 times the wealth of families in the middle."),
                            leafletOutput("map","100%", "400px"),
                            # --- new not -- do not forget the comma above!
                                      h2("ZIP explorer"),
                                      
                                      selectInput("color", "Color", vars),
                                      selectInput("size", "Size", vars, selected = "quantity"),
                                      conditionalPanel("input.color == 'records' || input.size == 'records'",
                                                       # Only prompt for threshold when coloring or sizing by records
                                                       numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
                                      ),
                                      
                                      plotOutput("histCentile", height = 200),
                                      plotOutput("scatterCollegeIncome", height = 250)
                        
                            # --- new
                     )
                   ),
                   # ----------------------------------------
                   # Point 2 --------------------------------
                   # ----------------------------------------
                   fluidRow(
                     column(width = 12,
                            tags$h1("_____________", style = "color:red; text-align:center; font-size: 20px;"),
                            h2(span(". ", style = "background-color:red; color:red; font-size: 120%;"),
                               span("2 ", style = "background-color:red; font-size: 120%;"),
                               span(".", style = "background-color:red; color:red; font-size: 120%;"),
                               span("-", style = "color:white; font-size: 120%;"),"This is the main tiltle of the paragraph.")
                     )
                   ),
                   fluidRow(
                     column(width = 4,
                            h4("2These changes have increased wealth inequality significantly. In 1963, families near the top had six times the wealth (or, $6 for every $1) of families in the middle. By 2013, they had 12 times the wealth of families in the middle.")
                     ),
                     column(width = 8,
                            h4("3These changes have increased wealth inequality significantly. In 1963, families near the top had six times the wealth (or, $6 for every $1) of families in the middle. By 2013, they had 12 times the wealth of families in the middle."),
                            tags$code("Tidy data sets are all the same. Each messy data set is messy in its own way.", cite = "Hadley Wickham")
                     )
                   ),
                   # ----------------------------------------
                   # Conclusion -----------------------------
                   # ---------------------------------------- 
                   fluidRow(
                     column(width = 12,
                            tags$h1("_____________", style = "color:red; text-align:center; font-size: 20px;"),
                            h2(span(".. ", style = "background-color:red; color:red; font-size: 120%;"),
                               span("...", style = "background-color:red; color:red; font-size: 120%;"),
                               span("-", style = "color:white; font-size: 120%;"),"This is the conclusion."),
                            p("p creates a paragraph of text."),
                            p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph."),
                            strong("strong() makes bold text."),
                            em("em() creates italicized (i.e, emphasized) text."),
                            br(),
                            code("code displays your text similar to computer code"),
                            div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
                            br(),
                            p("span does the same thing as div, but it works with",
                              span("groups of words", style = "color:blue"),
                              "that appear inside a paragraph.")
                     )
                   )
            ),
            column(width = 1
            )
          ),
          # 3 ---
          fluidRow(
            column(width = 12,
                   img(src="olives.jpg", height = "100%", width = "100%")
            )
          )
)



