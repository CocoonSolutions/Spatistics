datainput1 = readRDS("data/datainput1.rds") # <> 2017

datainput2links = readRDS("data/datainput2links.rds")
datainput2nodes = readRDS("data/datainput2nodes.rds")

datainput0 = readRDS("data/datainput0.rds")

# data3trans2, data3country = source tables in local postgres/project2

# reduce granularity from date to month
datainput3 = readRDS("data/datainput3.rds")

# Determine years
years <- unique(as.integer(datainput0$issueyear))
