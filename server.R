library(leaflet)

# allow uploading large files ---
if(Sys.getenv('SHINY_PORT') == "") options(shiny.maxRequestSize=10000*1024^2)

function(input, output, session) {
  
  # Create and render map ---
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 0, lat = 37.45, zoom = 3)
  })
  
}
