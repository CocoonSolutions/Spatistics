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
      return(datainput1[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(datainput1,
           latitude >= latRng[1] & latitude <= latRng[2] &
             longtitude >= lngRng[1] & longtitude <= lngRng[2])
  })
  
  # Precalculate the breaks we'll need for the two histograms
  centileBreaks <- hist(plot = FALSE, datainput1$cumulfreqnum, breaks = 20)$breaks
  
  output$histCentile <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    ggplot(data=zipsInBounds(), aes(zipsInBounds()$cumulfreqnum)) + 
      geom_histogram(breaks=centileBreaks, 
                     alpha = .2) + 
      geom_density(col=2) + 
      labs(title="Cumulative Frequency (visible countries)") +
      labs(x="Cumulative Frequency of Sales", y="Count")
  })
  
  output$scatterCollegeIncome <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    ggplot(zipsInBounds(), aes(x=cnt, y=sales_c, color=cumulfreqnum)) + geom_point() + geom_rug() + xlab("Total Number of Orders") + ylab("Total Sales")
  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    
    if (colorBy == "cumulfreqnum") {
      # Color and palette are treated specially in the "sales_q" case, because
      # the values are categorical instead of continuous.
      colorData <- ifelse(datainput1$cumulfreqnum >= input$threshold, "Over threshold", "Under threshold")
      pal <- colorFactor("viridis", colorData)
    } else {
      colorData <- datainput1[[colorBy]]
      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    }
    
      radius <- datainput1[[sizeBy]] / max(datainput1[[sizeBy]]) * 600000
    
    leafletProxy("map", data = datainput1) %>%
      clearShapes() %>%
      addCircles(~longtitude, ~latitude, radius=radius, layerId=~country,
                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  # Show a popup at the given location
  showZipcodePopup <- function(country, lat, lng) {
    selectedZip <- datainput1[datainput1$country == country,]
    content <- as.character(tagList(
      tags$h4(tags$strong(HTML(sprintf("%s",selectedZip$country)))), tags$br(),
      sprintf("Cumulative frequency: %s", as.integer(selectedZip$cumulfreqnum)), tags$br(),
      sprintf("Total sales: %s euros", format(as.integer(selectedZip$sales_c), big.mark=",", scientific=FALSE)), tags$br(),
      sprintf("Total sales quantity: %s kgs", format(as.integer(selectedZip$sales_q), big.mark=",", scientific=FALSE)), tags$br(),
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
