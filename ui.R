library("leaflet")

library('networkD3')

# --- new
# Choices for drop-downs
vars <- c(
  "Quantity" = "sales_q",
  "Cumulative Frequency of Sales" = "cumulfreqnum",
  "Sales" = "sales_c",
  "Total Number of Orders" = "cnt"
)
# --- new

fluidPage(
  theme = "bootstrap.css",
  
  # Include our custom CSS  and js ---
  tags$head(#includeCSS("styles.css"),
    includeScript("gomap.js")),
  
  # 1 ---
  fluidRow(column(
    width = 12,
    img(
      src = "Untitled-3.jpg",
      height = "100%",
      width = "100%"
    )
    
  )),
  
  # 2 ---
  fluidRow(
    column(width = 1),
    
    # 2.1 ---
    column(
      width = 10,
      h2("This is the main tiltle of the story."),
      h4(
        "This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story. This is a small paragraph with questions regarding the story."
      ),
      
      # 2.1.1 ---
      # ----------------------------------------
      # Point 1 --------------------------------
      # ----------------------------------------
      fluidRow(column(
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
        column(
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
        column(
          width = 8,
          h4(
            "3Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          ),
          leafletOutput("map", "100%", "400px"),
          # --- new not -- do not forget the comma above!
          br(),
          fluidRow(
            column(
              width = 4,
              selectInput("color", "Color", vars, selected = "cnt"),
              selectInput("size", "Size", vars, selected = "sales_c"),
              conditionalPanel(
                "input.color == 'cumulfreqnum'",
                # Only prompt for threshold when coloring or sizing by sales_q
                numericInput("threshold", "Cumulative Sales threshold", 50)
              )
            ),
            column(width = 8,
                   plotOutput("histCentile", height = 200))
          ),
          column(width = 12,
                 plotOutput("scatterCollegeIncome", height = 250))
          # --- new
        )
      ),
      # ----------------------------------------
      # Point 2 --------------------------------
      # ----------------------------------------
      fluidRow(column(
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
      fluidRow(column(
        width = 4,
        h4(
          "2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        )
      ),
      column(
        width = 8,
        tabPanel(
          "Force Network",
          forceNetworkOutput("force", width = "100%", height = "200px")
        ),
        h4(
          "3Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        )
      )),
      # ----------------------------------------
      # Conclusion -----------------------------
      # ----------------------------------------
      fluidRow(
        column(
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
    column(width = 1)
  ),
  # 3 ---
  fluidRow(column(
    width = 12,
    img(
      src = "Untitled-4.jpg",
      height = "100%",
      width = "100%"
    )
  ))
)
