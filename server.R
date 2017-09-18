library("leaflet")
library("RColorBrewer")
library("scales")
library("lattice")
library("dplyr")
library("ggplot2")

library('networkD3')
library("highcharter")

library('sqldf')
library('forecast')

# allow uploading large files ---
if (Sys.getenv('SHINY_PORT') == "")
  options(shiny.maxRequestSize = 10000 * 1024 ^ 2)

shinyServer(function(input, output, session) {
  # Map integration ------------------------------
  
  # Create and render map ---
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = -1,
              lat = 47.45,
              zoom = 4)
  })
  
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  zipsInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(datainput1[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(
      datainput1,
      latitude >= latRng[1] & latitude <= latRng[2] &
        longtitude >= lngRng[1] & longtitude <= lngRng[2]
    )
  })
  
  # Precalculate the breaks we'll need for the two histograms
  centileBreaks <-
    hist(plot = FALSE,
         datainput1$cumulfreqnum,
         breaks = 20)$breaks
  
  output$histCentile <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    ggplot(data = zipsInBounds(), aes(zipsInBounds()$cumulfreqnum)) +
      geom_histogram(breaks = centileBreaks,
                     alpha = .2) +
      labs(title = "Cumulative Frequency (visible countries)") +
      labs(x = "Cumulative Frequency of Sales", y = "Count")
  })
  
  output$scatterCollegeIncome <- renderPlot({
    # If no zipcodes are in view, don't plot
    if (nrow(zipsInBounds()) == 0)
      return(NULL)
    
    ggplot(zipsInBounds(),
           aes(x = sales_q, y = sales_c, color = cumulfreqnum)) + geom_point() + geom_rug() + xlab("Total Quantity") + ylab("Total Sales")
  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$color
    sizeBy <- input$size
    
    if (colorBy == "cumulfreqnum") {
      # Color and palette are treated specially in the "sales_q" case, because
      # the values are categorical instead of continuous.
      colorData <-
        ifelse(
          datainput1$cumulfreqnum >= input$threshold,
          "Over threshold",
          "Under threshold"
        )
      pal <-
        colorFactor("plasma", colorData) # "viridis", "magma", "inferno", or "plasma"
    } else {
      colorData <- datainput1[[colorBy]]
      pal <-
        colorBin("plasma", colorData, 7, pretty = FALSE) # "viridis", "magma", "inferno", or "plasma"
    }
    
    radius <-
      datainput1[[sizeBy]] / max(datainput1[[sizeBy]]) * 600000
    
    leafletProxy("map", data = datainput1) %>%
      clearShapes() %>%
      addCircles(
        ~ longtitude,
        ~ latitude,
        radius = radius,
        layerId =  ~ country,
        stroke = FALSE,
        fillOpacity = 0.4,
        fillColor = pal(colorData)
      ) %>%
      addLegend(
        "bottomleft",
        pal = pal,
        values = colorData,
        title = colorBy,
        layerId = "colorLegend"
      )
  })
  
  # Show a popup at the given location
  showZipcodePopup <- function(country, lat, lng) {
    selectedZip <- datainput1[datainput1$country == country,]
    content <- as.character(
      tagList(
        tags$h4(tags$strong(HTML(
          sprintf("%s", selectedZip$country)
        ))),
        tags$br(),
        sprintf(
          "Cumulative frequency of Sales: %s",
          as.integer(selectedZip$cumulfreqnum)
        ),
        tags$br(),
        sprintf(
          "Total sales: %s euros",
          format(
            as.integer(selectedZip$sales_c),
            big.mark = ",",
            scientific = FALSE
          )
        ),
        tags$br(),
        sprintf(
          "Total sales quantity: %s kgs",
          format(
            as.integer(selectedZip$sales_q),
            big.mark = ",",
            scientific = FALSE
          )
        ),
        tags$br(),
        sprintf(
          "Total number of orders: %s",
          format(
            as.integer(selectedZip$cnt),
            big.mark = ",",
            scientific = FALSE
          )
        ),
        tags$br(),
        tags$br(),
        sprintf(
          "Population 2016: %s people",
          format(
            as.integer(selectedZip$pop2016),
            big.mark = ",",
            scientific = FALSE
          )
        ),
        tags$br(),
        sprintf(
          "Gross Domestic Product 2016: %s euros",
          format(
            as.integer(selectedZip$gdp2016),
            big.mark = ",",
            scientific = FALSE
          )
        ),
        tags$br()
      )
    )
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
  
  # Network integration ------------------------------
  
  output$force <- renderForceNetwork({
    forceNetwork(
      Links = datainput2links,
      Nodes = datainput2nodes,
      Source = "source",
      Target = "target",
      Value = "linkvalue",
      NodeID = "nodeid",
      Group = "nodegroup",
      opacity = 1,
      fontSize = 20,
      zoom = FALSE,
      linkDistance = JS("function(d){return d.value * 20}"),
      linkWidth = JS("function(d) { return Math.sqrt(d.value)*1.9; }"),
      legend = TRUE,
      colourScale = JS(
        'force.alpha(1); force.restart(); d3.scaleOrdinal(d3.schemeCategory20);'
      )
    )
  })
  
  # Highchart integration ------------------------------
  
  # Calculate sales
  diff13 <- reactive({
    if (input$metric == 'sales') {
    datainput0 %>%
      filter(as.integer(issueyear) == input$year[1]) %>%
      group_by(rank = as.integer(substr(itemsizerank, 1, 2)) + 1) %>%
      summarise(total=sum(sales)) %>%
      arrange(rank)
    } else {
    datainput0 %>%
      filter(as.integer(issueyear) == input$year[1]) %>%
      group_by(rank = as.integer(substr(itemsizerank, 1, 2)) + 1) %>%
      summarise(total=sum(quantity)) %>%
      arrange(rank)
    }
  })
  
  # Text string of selected years for plot subtitle
  selected_years_to_print <- reactive({
      paste(input$year[1])
  })
  
  # Highchart
  output$hcontainer <- renderHighchart({
    if (input$metric == 'sales') {
    hc <- highchart() %>%
      hc_add_series(
        data = diff13()$total,
        type = input$plot_type,
        name = "Sales",
        showInLegend = FALSE,
        color = "#44a3c6",
        dataLabels = list(align = "center", enabled = TRUE, color = "#44a3c6")
      ) %>%
      hc_yAxis(title = list(text = "Sales"),
               allowDecimals = FALSE, max= 80000000) %>%
      hc_xAxis(
        categories = c(
          "SPECIALCUTS",
          "STORTI",
          "150-200",
          "200-300",
          "300-400",
          "300-600",
          "400-600",
          "600-800",
          "500-1000",
          "800-1000",
          "1000-1500",
          "1000-2000",
          "1500-2000",
          "2000+",
          "2000-3000",
          "3000-4000",
          "4000+"
        ),
        tickmarkPlacement = "on",
        opposite = TRUE
      ) %>%
      hc_title(text = "Total sales",
               style = list(fontWeight = "bold")) %>%
      hc_subtitle(text = paste("Subtitle here,",
                               selected_years_to_print())) %>%
      hc_tooltip(valueDecimals = 2,
                 pointFormat = "Item Size Rank (1-17) : {point.x} <br> Sales: {point.y}€")
    } else {
          hc <- highchart() %>%
      hc_add_series(
        data = diff13()$total,
        type = input$plot_type,
        name = "Quantity",
        showInLegend = FALSE,
        color = "#c66545",
        dataLabels = list(align = "center", enabled = TRUE, color = "#c66545")
      ) %>%
      hc_yAxis(title = list(text = "Quantity"),
               allowDecimals = FALSE, max= 15000000) %>%
      hc_xAxis(
        categories = c(
          "SPECIALCUTS",
          "STORTI",
          "150-200",
          "200-300",
          "300-400",
          "300-600",
          "400-600",
          "600-800",
          "500-1000",
          "800-1000",
          "1000-1500",
          "1000-2000",
          "1500-2000",
          "2000+",
          "2000-3000",
          "3000-4000",
          "4000+"
        ),
        tickmarkPlacement = "on",
        opposite = TRUE
      ) %>%
      hc_title(text = "Total quantity",
               style = list(fontWeight = "bold")) %>%
      hc_subtitle(text = paste("Subtitle here,",
                               selected_years_to_print())) %>%
      hc_tooltip(valueDecimals = 2,
                 pointFormat = "Item Size Rank (1-17) : {point.x} <br> Quantity: {point.y}Kgrs")
    }
    
    # Print highchart
    hc
  }) 
  
  # Highchart integrations ------------------------------
  
  output$highchartforecast <- renderHighchart({
   a = sqldf("Select issueyearmon, sum(sales) sales from datainput3 where issueyearmon <> '2017-08' Group By issueyearmon order by    issueyearmon")
   a$ts = ts(a$sales, start=c(2013, 1), end=c(2017, 7), frequency=12)
   d.arima <- auto.arima(a$ts)
   x <- forecast(d.arima, level = c(95, 80), h = 12)
   hchart(x)
  })

})