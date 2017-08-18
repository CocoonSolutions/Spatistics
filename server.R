library(leaflet)

# allow uploading large files ---
if(Sys.getenv('SHINY_PORT') == "") options(shiny.maxRequestSize=10000*1024^2)

function(input, output, session) {
  
  # import data from csv file ---
  output$contents <- renderTable({
    # checking for required file ---
    req(input$file1)
    # read uploaded file and save into local var ---
    data <- read.csv(input$file1$datapath,
                   header = input$header,
                   sep = input$sep,
                   quote = input$quote)
    head(data)
  })
  
   output$count <- renderPrint({
     nrow(data)
   })
   
  # Create and render map ---
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 0, lat = 37.45, zoom = 3)
  })
  
}
