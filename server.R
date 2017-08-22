library("leaflet")
library("RColorBrewer")
library("scales")
library("lattice")
library("dplyr")
library("ggplot2")

# allow uploading large files ---
if(Sys.getenv('SHINY_PORT') == "") options(shiny.maxRequestSize=10000*1024^2)

function(input, output, session) {
  
  # Map integration ------------------------------
  
  # Create and render map ---
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 5, lat = 47.45, zoom = 4)
  })
  # --- new
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(datacountries[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(datacountries,
           lat >= latRng[1] & lat <= latRng[2] &
             lon >= lngRng[1] & lon <= lngRng[2])
  })
  
  # Precalculate the breaks we'll need for the two histograms
  centileBreaks <- hist(plot = FALSE, datacountries$cumulfreqnum, breaks = 20)$breaks
  
  output$histCentile <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    ggplot(data=zipsInBounds(), aes(zipsInBounds()$cumulfreqnum)) + 
      geom_histogram(breaks=centileBreaks, 
                     alpha = .2) + 
      geom_density(col=2) + 
      labs(title="Cumulative Frequency (visible countries)") +
      labs(x="Cumulative Frequency of Quantity", y="Count")
  })
  
  output$scatterCollegeIncome <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    ggplot(zipsInBounds(), aes(x=cnt, y=quantity, color=cumulfreqnum)) + geom_point() + geom_rug() + xlab("Total Number of Orders")
  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    
    if (colorBy == "records") {
      # Color and palette are treated specially in the "records" case, because
      # the values are categorical instead of continuous.
      colorData <- ifelse(datacountries$cumulfreqnum >= (100 - input$threshold), "yes", "no")
      pal <- colorFactor("viridis", colorData)
    } else {
      colorData <- datacountries[[colorBy]]
      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    }
    
    if (sizeBy == "records") {
      # Radius is treated specially in the "records" case.
      radius <- ifelse(datacountries$cumulfreqnum >= (100 - input$threshold), 300000, 30000)
    } else {
      radius <- datacountries[[sizeBy]] / max(datacountries[[sizeBy]]) * 600000
    }
    
    leafletProxy("map", data = datacountries) %>%
      clearShapes() %>%
      addCircles(~lon, ~lat, radius=radius, layerId=~country,
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  # Show a popup at the given location
  showZipcodePopup <- function(country, lat, lng) {
    selectedZip <- datacountries[datacountries$country == country,]
    content <- as.character(tagList(
      tags$h4(tags$strong(HTML(sprintf("%s",selectedZip$country)))), tags$br(),
      sprintf("Cumulative Frequency: %s", as.integer(selectedZip$cumulfreqnum)), tags$br(),
      sprintf("Total quantity of olives: %s kg", format(as.integer(selectedZip$quantity), big.mark=",", scientific=FALSE)), tags$br(),
      sprintf("Total number of orders: %s", format(as.integer(selectedZip$cnt), big.mark=",", scientific=FALSE)), tags$br()
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
