library(leaflet)

# Choices for drop-downs ---
vars <- c(
  "Is SuperZIP?" = "superzip",
  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)

fluidPage(theme = "bootstrap.css",
          navbarPage("My Application",
                     tabPanel("Import Data",
                              # Sidebar layout with input and output definitions ----
                              sidebarLayout(
                                # Sidebar panel for inputs ----
                                sidebarPanel(
                                  # Input: Select a file ----
                                  fileInput("file1", "Choose CSV File:",
                                            multiple = TRUE,
                                            accept = c("text/csv",
                                                       "text/comma-separated-values,text/plain",
                                                       ".csv")),
                                  # Input: Checkbox if file has header ----
                                  checkboxInput("header", "Header", TRUE),
                                  # Input: Select separator ----
                                  radioButtons("sep","Choose Separator:",
                                               choices = c(Comma = ",",
                                                           Semicolon = ";",
                                                           Tab = "\t"),
                                               selected = ","),
                                  # Input: Select quotes ----
                                  radioButtons("quote", "Choose Text Quotes:",
                                               choices = c(None = "",
                                                           "Double Quote" = '"',
                                                           "Single Quote" = "'"),
                                               selected = '"')
                                ),
                                # Main panel for displaying outputs ----
                                mainPanel(
                                  # Output: Data file ----
                                  tableOutput("contents")
                                )
                              )
                     ),
                     tabPanel("Visualize",
                              div(class="outer",
                                  
                                  tags$head(
                                    # Include our custom CSS
                                    includeCSS("styles.css"),
                                    includeScript("gomap.js")
                                  ),
                                  
                                  leafletOutput("map", width="100%", height="100%")
                              )
                     ),
                     tabPanel("Component 2"),
                     navbarMenu("More",
                                tabPanel("Sub-Component A"),
                                tabPanel("Sub-Component B"))
          )
)