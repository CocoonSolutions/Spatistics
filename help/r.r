#-- run app with shiny
runApp("App-1")

#-- display in showcase mode
runApp("App-1", display.mode = "showcase")

#-- load csv
data = read.csv("C:/Users/PC001/Desktop/StoryTelling/gitRepo/data/data1trans2.csv")

#-- shiny leaflet quick implementation
app = shinyApp(
  ui = fluidPage(leafletOutput('myMap')),
  server = function(input, output) {
    map = leaflet() %>% addProviderTiles(providers$CartoDB.Positron)
    output$myMap = renderLeaflet(map)
  }
)
#-- render in browser
if (interactive())
  print(app)

#-- shiny server import csv
# import data from csv file ---
output$contents <- renderTable({
  # checking for required file ---
  req(input$file1)
  # read uploaded file and save into local var ---
  data <- read.csv(
    input$file1$datapath,
    header = input$header,
    sep = input$sep,
    quote = input$quote
  )
  head(data)
})
#-- shiny ui import csv
tabPanel("Import Data",
         # Sidebar layout with input and output definitions ----
         sidebarLayout(
           # Sidebar panel for inputs ----
           sidebarPanel(
             # Input: Select a file ----
             fileInput(
               "file1",
               "Choose CSV File:",
               multiple = TRUE,
               accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")
             ),
             # Input: Checkbox if file has header ----
             checkboxInput("header", "Header", TRUE),
             # Input: Select separator ----
             radioButtons(
               "sep",
               "Choose Separator:",
               choices = c(
                 Comma = ",",
                 Semicolon = ";",
                 Tab = "\t"
               ),
               selected = ","
             ),
             # Input: Select quotes ----
             radioButtons(
               "quote",
               "Choose Text Quotes:",
               choices = c(
                 None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"
               ),
               selected = '"'
             )
           ),
           # Main panel for displaying outputs ----
           mainPanel(# Output: Data file ----
                     tableOutput("contents"))
         ))

#-- execute sql in dataframes
library(sqldf)
data1 = sqldf(
  "select data.countryname2 country, data.lon, data.lat, count(*) cnt, sum(data.quantity) quantity from data group by data.countryname2, data.lon, data.lat order by sum(data.quantity)"
)
#-- add column depending on existing column
data1$records <- ifelse(data1$cnt < 10000, 0, 1)

#-- save and load rds
saveRDS(
  datacountries,
  "C:/Users/PC001/Desktop/StoryTelling/gitRepo/data/datacountries.rds"
)
datacountries = readRDS("C:/Users/PC001/Desktop/StoryTelling/gitRepo/data/datacountries.rds")

#-- clear r variables
rm(list = ls()[!(ls() %in% c('data'))])

#-- export df to csv
write.table(datainput0, file = "C:/Users/PC001/Desktop/datainput0.csv", append = FALSE, quote = TRUE, sep = ";",
             eol = "\n", na = "NA", dec = ".", row.names = TRUE,
             col.names = TRUE, qmethod = c("escape", "double"),
             fileEncoding = "")

#-- scatter plot
ggplot(datainput0, aes(x=sales, y=quantity, color=issueyear)) + 
   geom_point()

#-- bar plot
ggplot(datainput0, aes(fill=itemsizerank, y=sales, x=issueyear)) + geom_bar(position="dodge", stat="identity") + ylim(c(0,10000))

###################################################################################
#-- CREATE DATA INPUT 1 --
###################################################################################
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(
  drv,
  dbname = "project2",
  host = "localhost",
  port = 5432,
  user = "postgres",
  password = "postgres"
)

datainput1 = dbGetQuery(
  con,
  "select a.*, b.cnt, b.sales_q, b.sales_c from data3country a join (select country, count(*) cnt, sum(sales) sales_c, sum(quantity) sales_q from data3trans1 where to_char(issuedate, 'YYYY') <> '2017' group by country) b on upper(a.country2) = b.country"
)

dbDisconnect(con)
#-- order
datainput1 = datainput1[order(datainput1$sales_c),]
#-- add cumulative
datainput1$cumul = cumsum(datainput1$sales_c)
#-- add cumulative frequency as character
datainput1$cumulfreqnum = 100 * datainput1$cumul / sum(datainput1$sales_c)
datainput1$cumulfreqnum = as.numeric(format(round(datainput1$cumulfreqnum, 2), nsmall = 2))
#-- save rds
saveRDS(datainput1,
        "C:/Users/PC001/Desktop/StoryTelling/gitRepo/data/datainput1.rds")

###################################################################################
#-- CREATE DATA INPUT 2 --
###################################################################################
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(
  drv,
  dbname = "project2",
  host = "localhost",
  port = 5432,
  user = "postgres",
  password = "postgres"
)

datainput2links = dbGetQuery(
  con,
  "-- links
  select b.id source, c.id target, linkvalue
  from (
  select distinct itemline source, itemcategory target, 5 linkvalue
  from data3trans1
  union all
  select distinct itemcategory source, itemgroup target, 3 linkvalue
  from data3trans1
  union all
  select distinct itemgroup source, itemsize target, 1 linkvalue
  from data3trans1
  ) d
  left join
  (select a1.*, row_number() over ()-1 as id
  from (
  select distinct itemline nodeID, 'Product Line' nodeGroup
  from data3trans1
  union all
  select distinct itemcategory nodeID, 'Product Category' nodeGroup
  from data3trans1
  union all
  select distinct itemgroup nodeID, 'Product Name' nodeGroup
  from data3trans1
  union all
  select distinct itemsize nodeID, 'Product Size' nodeGroup
  from data3trans1
  ) a1) b on source=b.nodeid
  left join
  (select a2.*, row_number() over ()-1 as id
  from (
  select distinct itemline nodeID, 'Product Line' nodeGroup
  from data3trans1
  union all
  select distinct itemcategory nodeID, 'Product Category' nodeGroup
  from data3trans1
  union all
  select distinct itemgroup nodeID, 'Product Name' nodeGroup
  from data3trans1
  union all
  select distinct itemsize nodeID, 'Product Size' nodeGroup
  from data3trans1
  ) a2) c on target=c.nodeID;"
)

datainput2nodes = dbGetQuery(
  con,
  "-- nodes
  select a.*, row_number() over () -1 as id
  from (
  select distinct itemline nodeID, 'Product Line' nodeGroup
  from data3trans1
  union all
  select distinct itemcategory nodeID, 'Product Category' nodeGroup
  from data3trans1
  union all
  select distinct itemgroup nodeID, 'Product Name' nodeGroup
  from data3trans1
  union all
  select distinct itemsize nodeID, 'Product Size' nodeGroup
  from data3trans1
  ) a;"
)

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
  legend = TRUE
)
#-- save rds
saveRDS(
  datainput2links,
  "C:/Users/PC001/Desktop/StoryTelling/gitRepo/data/datainput2links.rds"
)
saveRDS(
  datainput2nodes,
  "C:/Users/PC001/Desktop/StoryTelling/gitRepo/data/datainput2nodes.rds"
)

###################################################################################
#-- CREATE DATA INPUT 0 --
###################################################################################
library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")
con <- dbConnect(
  drv,
  dbname = "project2",
  host = "localhost",
  port = 5432,
  user = "postgres",
  password = "postgres"
)
datainput0 = dbGetQuery(con, "select * from data3trans2;")
dbDisconnect(con)
#-- save rds
saveRDS(
  datainput0,
  "C:/Users/PC001/Desktop/StoryTelling/gitRepo/data/datainput0.rds"
)