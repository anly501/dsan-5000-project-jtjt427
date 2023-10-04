library(httr)
library(jsonlite)
library(stringr)
library(tm)
library(dplyr)

baseURL <- "https://newsapi.org/v2/everything?"
total_requests <- 2
verbose <- TRUE

# THIS CODE WILL NOT WORK UNLESS YOU INSERT YOUR API KEY IN THE NEXT LINE
API_KEY <- '7623798eeb714a3083e6e9f49af33fc3'
TOPIC <- 'wildfire prevention'

URLpost <- list(
  apiKey = API_KEY,
  q = paste('+', TOPIC),
  sortBy = 'relevancy',
  totalRequests = total_requests
)

# GET DATA FROM API
response <- GET(baseURL, query = URLpost)

response_text = rawToChar(response$content)

# Parse the JSON response
response_data <- fromJSON(response_text)

articles <- response_data$articles

write_json(articles, "data/raw-data/articles.json")
