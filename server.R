library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# allow uploading large files ---
if(Sys.getenv('SHINY_PORT') == "") options(shiny.maxRequestSize=10000*1024^2)

function(input, output, session) {
  
  # Map integration ------------------------------
  
  # Create and render map ---
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 0, lat = 37.45, zoom = 3)
  })
  # --- new
   # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(data1[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(data1,
           lat >= latRng[1] & lat <= latRng[2] &
             lon >= lngRng[1] & lon <= lngRng[2])
  })
  
  # Precalculate the breaks we'll need for the two histograms
  centileBreaks <- hist(plot = FALSE, data1$cumulfreqnum, breaks = 20)$breaks
  
  output$histCentile <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    hist(zipsInBounds()$cumulfreqnum,
         breaks = centileBreaks,
         main = "records score (visible zips)",
         xlab = "Percentile",
         xlim = range(data1$cumulfreqnum),
         col = '#00DD00',
         border = 'white')
  })
  
  output$scatterCollegeIncome <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    print(xyplot(quantity ~ cnt, data = zipsInBounds(), xlim = range(data1$cnt), ylim = range(data1$quantity)))
  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    
    if (colorBy == "records") {
      # Color and palette are treated specially in the "records" case, because
      # the values are categorical instead of continuous.
      colorData <- ifelse(data1$cumulfreqnum >= (100 - input$threshold), "yes", "no")
      pal <- colorFactor("viridis", colorData)
    } else {
      colorData <- data1[[colorBy]]
      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    }
    
    if (sizeBy == "records") {
      # Radius is treated specially in the "records" case.
      radius <- ifelse(data1$cumulfreqnum >= (100 - input$threshold), 30000, 3000)
    } else {
      radius <- data1[[sizeBy]] / max(data1[[sizeBy]]) * 30000
    }
    
    leafletProxy("map", data = data1) %>%
      clearShapes() %>%
      addCircles(~lon, ~lat, radius=radius, layerId=~country,
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  # Show a popup at the given location
  showZipcodePopup <- function(country, lat, lng) {
    selectedZip <- data1[data1$country == country,]
    content <- as.character(tagList(
      tags$h4("Score:", as.integer(selectedZip$cumulfreqnum)),
      tags$strong(HTML(sprintf("%s, %s %s",
                               selectedZip$country, selectedZip$country, selectedZip$country
      ))), tags$br(),
      sprintf("Median household quantity: %s", dollar(selectedZip$quantity * 1000)), tags$br(),
      sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$cnt)), tags$br()
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = country)
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showZipcodePopup(event$id, event$lat, event$lng)
    })
  })
  # --- new
  
}
