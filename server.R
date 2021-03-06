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
      return(datainput1[FALSE, ])
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
        colorFactor("viridis", colorData) # "viridis", "magma", "inferno", or "plasma"
    } else {
      colorData <- datainput1[[colorBy]]
      pal <-
        colorBin("viridis", colorData, 7, pretty = FALSE) # "viridis", "magma", "inferno", or "plasma"
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
    selectedZip <- datainput1[datainput1$country == country, ]
    content <- as.character(
      tagList(
        tags$h4(tags$strong(HTML(
          sprintf("%s", selectedZip$country)
        ))),
        tags$br(),
        sprintf(
          "Cumulative frequency of Sales 2016: %s",
          as.integer(selectedZip$cumulfreqnum)
        ),
        tags$br(),
        sprintf(
          "Total sales 2016: %s €",
          format(
            as.integer(selectedZip$sales_c),
            big.mark = ",",
            scientific = FALSE
          )
        ),
        tags$br(),
        sprintf(
          "Total sales quantity 2016: %s kgs",
          format(
            as.integer(selectedZip$sales_q),
            big.mark = ",",
            scientific = FALSE
          )
        ),
        tags$br(),
        sprintf(
          "Total number of orders 2016: %s",
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
          "Gross Domestic Product 2016: %s €",
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
        summarise(total = sum(sales)) %>%
        arrange(rank)
    } else {
      datainput0 %>%
        filter(as.integer(issueyear) == input$year[1]) %>%
        group_by(rank = as.integer(substr(itemsizerank, 1, 2)) + 1) %>%
        summarise(total = sum(quantity)) %>%
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
          color = "#7cb5ec"
        ) %>%
        hc_yAxis(
          title = list(text = "Sales (€)"),
          allowDecimals = FALSE,
          max = 80000000
        ) %>%
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
        hc_title(text = "",
                 style = list(fontWeight = "bold")) %>%
        hc_subtitle(text = paste("Total", input$metric, " per size for the year of",
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
          color = "#90ed7d"
          ) %>%
        hc_yAxis(
          title = list(text = "Quantity (kgrs)"),
          allowDecimals = FALSE,
          max = 15000000
        ) %>%
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
        hc_title(text = "",
                 style = list(fontWeight = "bold")) %>%
        hc_subtitle(text = paste("Total", input$metric, " per size for the year of",
                                 selected_years_to_print())) %>%
        hc_tooltip(valueDecimals = 2,
                   pointFormat = "Item Size Rank (1-17) : {point.x} <br> Quantity: {point.y} Kgrs")
    }
    
    # Print highchart
    hc
  })
  
  # Highchart integrations ------------------------------
  
  # point 9 forecast
  output$highchartforecast <- renderHighchart({
    a01 = sqldf(
      "Select issueyearmon, sum(sales) sales from datainput3 where issueyearmon <> '2017-08' Group By issueyearmon order by issueyearmon"
    )
    a01$ts = ts(
      a01$sales,
      start = c(2013, 1),
      end = c(2017, 7),
      frequency = 12
    )
    d.arima <- auto.arima(a01$ts)
    x <- forecast(d.arima, level = c(95, 80), h = 12)
    hchart(x)
  })
  
  # point 2 pie chart
  output$highchart2 <- renderHighchart({
    a02 = sqldf(
      "Select 'Sales inside Greece', sum(sales) sales from datainput3 where country = 'GREECE' union Select 'Sales outside Greece', sum(sales) sales from datainput3 where country <> 'GREECE' "
    )
    a02$saleRatio = as.numeric(format(round(100 * a02$sales / sum(a02$sales), 2), nsmall = 2))
    highchart() %>%
      hc_title(text = "") %>%
      hc_subtitle(text = "Percentage of Total Sales from Jan.2013 to Aug.2017") %>%
      hc_add_series_labels_values(
        c(
          paste(as.character(a02$saleRatio[[1]]), '% inside Greece'),
          paste(as.character(a02$saleRatio[[2]]), '% outside Greece')
        ),
        a02$saleRatio,
        type = "pie",
        name = "Percentage of sales",
        colorByPoint = TRUE,
        size = 200,
        color = c('#7cb5ec', '#bfbfbf')
      )
  })
  
  # point 3 area chart
  output$highchart3 <- renderHighchart({
    a03 = sqldf(
      "Select issuemonth Month, sum(sales) Sales, sum(quantity) Quantity, sum(sales)/sum(quantity) Price from datainput3 where issueyear != '2017' group by issuemonth"
    )
    
    highchart() %>%
      hc_subtitle(text = "Average Sales, Quantity and Selling Price per Month from Jan.2013 to Dec.2016") %>%
      hc_xAxis(
        plotBands = list(
          list(
            from = 4,
            to = 8,
            color = "rgba(100, 0, 0, 0.1)",
            label = list(text = "44.62% of Total Sales")
          )
        ),
        categories = c(
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        )
      ) %>%
      hc_add_series(name = "Average Sales (€)", data = a03$Sales/4) %>%
      hc_add_series(name = "Average Quantity (Kgrs)", data = a03$Quantity/4) %>%
      hc_add_series(name = "Average Price (€/kgrs)", data = a03$Price)
  })
  
  # point 5 area chart
  output$highchart5 <- renderHighchart({
    a051 = sqldf(
      "Select issueyearmon YearMon, sum(sales) Sales, sum(quantity) Quantity, sum(sales)/sum(quantity) Price from datainput3 where itemgroup='Seabream' and issueyearmon != '2017-08' group by issueyearmon"
    )
    a052 = sqldf(
      "Select issueyearmon YearMon, sum(sales) Sales, sum(quantity) Quantity, sum(sales)/sum(quantity) Price from datainput3 where itemgroup='Meagre' and issueyearmon != '2017-08' group by issueyearmon"
    )
    
    highchart() %>%
      hc_subtitle(text = "Trend of Selling Price and Quantity for Seabream and Meagre from Jan.2013 to Jul.2017") %>%
      hc_xAxis(categories = a051$YearMon,
               plotBands = list(
                 list(
                   from = 28,
                   to = 32,
                   color = "rgba(100, 0, 0, 0.1)",
                   label = list(text = "Top 5 Selling Prices")
                 )
               )) %>%
      hc_add_series(name = "Seabream Selling Price (€/kgr)", data = a051$Price) %>%
      hc_add_series(name = "Meagre Selling Price (€/kgr)", data = a052$Price) %>%
      hc_add_series(
        name = "Seabream Quantity in (Million kgrs)",
        data = a051$Quantity /
          1000000,
        type = 'area',
        color = '#d9d9d9'
      ) %>%
      hc_add_series(
        name = "Meagre Quantity in (Million kgrs)",
        data = a052$Quantity /
          1000000,
        type = 'area',
        color = '#d9d9d9'
      )
  })
  
  # point 6 area chart
  output$highchart6 <- renderHighchart({
    a06fillet = sqldf(
      "Select issueyearmon YearMon, sum(sales) Sales, sum(quantity) Quantity, sum(sales)/sum(quantity) Price from datainput3 where itemcategory='Fillet' and issueyearmon != '2017-08' group by issueyearmon"
    )
    a06gutted = sqldf(
      "Select issueyearmon YearMon, sum(sales) Sales, sum(quantity) Quantity, sum(sales)/sum(quantity) Price from datainput3 where itemcategory='Gutted' and issueyearmon != '2017-08' group by issueyearmon"
    )
    a06whole = sqldf(
      "Select issueyearmon YearMon, sum(sales) Sales, sum(quantity) Quantity, sum(sales)/sum(quantity) Price from datainput3 where itemcategory='Whole' and issueyearmon != '2017-08' group by issueyearmon"
    )
    a06 = sqldf(
      "Select itemcategory, sum(sales) Sales, sum(quantity) Quantity, sum(sales)/sum(quantity) Price from datainput3 where issueyearmon != '2017-08' group by itemcategory"
    )
    a06$quantityRatio = as.numeric(format(round(
      100 * a06$Quantity / sum(a06$Quantity), 2
    ), nsmall = 2))
    a06$SalesRatio = as.numeric(format(round(100 * a06$Sales / sum(a06$Sales), 2), nsmall = 2))
    highchart() %>%
      hc_chart(type = "line") %>%
      hc_subtitle(text = "Trend of Selling Price per Category from Jan.2013 to Jul.2017") %>%
      hc_xAxis(categories = a06gutted$YearMon) %>%
      hc_add_series(name = "Fillet (€/kgr)", data = a06gutted$Price) %>%
      hc_add_series(name = "Gutted (€/kgr)", data = a06fillet$Price) %>%
      hc_add_series(name = "Whole (€/kgr)", data = a06whole$Price)  %>%
      hc_add_series_labels_values(
        a06$itemcategory,
        a06$quantityRatio,
        type = "pie",
        name = "Percentage of total Quantity",
        colorByPoint = TRUE,
        center = c('65%', '38%'),
        size = 70,
        dataLabels = list(enabled = FALSE)
      ) %>%
      hc_add_series_labels_values(
        a06$itemcategory,
        a06$SalesRatio,
        type = "pie",
        name = "Percentage of total Sales",
        colorByPoint = TRUE,
        center = c('35%', '38%'),
        size = 70,
        dataLabels = list(enabled = FALSE)
      )
  })
  
  # point 7 area chart
  output$highchart71 <- renderHighchart({
    a071 = sqldf(
      "Select 'Top 10 Countries in Sales' label, 100*sum(sales_c)/599716802 percent from datainput1_legacy where cumulfreqnum > 12 union Select 'Rest of the Countries' label, 100*sum(sales_c)/599716802 percent from datainput1 where cumulfreqnum <= 12 "
    )
    a071$percent = as.numeric(format(a071$percent, digits = 4))
    highchart() %>%
      hc_subtitle(text = "Total Sales and Quantity per Country from Jan.2013 to Dec.2016") %>%
      hc_chart(type = "column") %>%
      hc_plotOptions(column = list(
        dataLabels = list(enabled = FALSE),
        stacking = "normal",
        enableMouseTracking = FALSE
      )) %>%
      hc_xAxis(categories = datainput1_legacy$code, plotBands = list(
        list(
          from = 28,
          to = 37,
          color = "rgba(100, 0, 0, 0.1)",
          label = list(text = "")
        )
      )) %>%
      hc_add_series(name = "Total Sales (€)", data = datainput1_legacy$sales_c) %>%
      hc_add_series(name = "Total Quantity (kgr)", data = datainput1_legacy$sales_q) %>%
      hc_add_series_labels_values(
        a071$label,
        a071$percent,
        type = "pie",
        name = "Percentage of Sales (%)",
        colorByPoint = TRUE,
        center = c('35%', '38%'),
        size = 100,
        color = c('#7cb5ec', '#90ed7d')
      )
  })
  
  output$highchart72 <- renderHighchart({
    datainput1_legacy$salesGroup = ifelse(
      datainput1_legacy$cumulfreqnum > 12,
      'Top 10 Countries in Sales',
      ifelse(
        datainput1_legacy$cumulfreqnum <= 12 &
          datainput1_legacy$cumulfreqnum > 1,
        'Countries with Medium Sales',
        'Countries with Less Sales'
      )
    )
    
    highchart() %>%
      hc_subtitle(text = "Comparing 2016 GDP and Total Population to Annual Average Sales per Country") %>%
      hc_chart(zoomType = "xy") %>%
      hc_add_series(
        dataLabels = list(enabled = TRUE,
                          format = "{point.label}"),
        data = datainput1_legacy,
        hcaes(
          x = gdp2016,
          y = pop2016,
          z = sales_c/4,
          group = salesGroup
        ),
        color = c('#434348', '#7cb5ec', '#90ed7d'),
        type = "scatter"
      ) %>%
      hc_tooltip(
        useHTML = TRUE,
        headerFormat = "<table>",
        pointFormat = paste(
          "<tr><th colspan=\"1\"><b>{point.label}</b></th></tr>",
          "<tr><th>Country</th><td>{point.country}</td></tr>",
          "<tr><th>GDP 2016</th><td>{point.x} €</td></tr>",
          "<tr><th>Population 2016</th><td>{point.y} people</td></tr>",
          "<tr><th>Total Sales</th><td>{point.z} €</td></tr>"
        ),
        footerFormat = "</table>"
      )
  })
  
})