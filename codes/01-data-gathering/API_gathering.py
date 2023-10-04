import requests
import sys
import pandas as pd

import json
                

response_20 = requests.request("GET", "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/california/2020-01-01/2020-12-31?unitGroup=metric&include=days%2Cevents&key=87T6FUFEU3JP8VEAKVQURPEVB&contentType=json")
if response_20.status_code!=200:
  print('Unexpected Status code: ', response_20.status_code)
  sys.exit()  


# Parse the results as JSON
jsonData = response_20.json()

# Convert the JSON data to a Pandas DataFrame
Cali_2020 = pd.DataFrame(jsonData['days'])

Cali_2020.to_csv('../data/raw-data/Cali_2020.csv', index=False)

response_17 = requests.request("GET", "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/california/2017-01-01/2017-12-31?unitGroup=metric&include=days%2Cevents&key=87T6FUFEU3JP8VEAKVQURPEVB&contentType=json")

# Parse the results as JSON
jsonData = response_17.json()
print(jsonData)

# Convert the JSON data to a Pandas DataFrame
Cali_2017 = pd.DataFrame(jsonData['days'])

Cali_2017.to_csv('../data/raw-data/Cali_2017.csv', index=False)

response_15 = requests.request("GET", "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/california/2015-01-01/2015-12-31?unitGroup=metric&include=days%2Cevents&key=87T6FUFEU3JP8VEAKVQURPEVB&contentType=json")

# Parse the results as JSON
jsonData = response_15.json()
print(jsonData)

# Convert the JSON data to a Pandas DataFrame
Cali_2015 = pd.DataFrame(jsonData['days'])

Cali_2015.to_csv('../data/raw-data/Cali_2015.csv', index=False)

response_14 = requests.request("GET", "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/california/2014-01-01/2014-12-31?unitGroup=metric&include=days%2Cevents&key=87T6FUFEU3JP8VEAKVQURPEVB&contentType=json")

# Parse the results as JSON
jsonData = response_14.json()
print(jsonData)

# Convert the JSON data to a Pandas DataFrame
Cali_2014 = pd.DataFrame(jsonData['days'])

Cali_2014.to_csv('../data/raw-data/Cali_2014.csv', index=False)

response_10 = requests.request("GET", "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/california/2010-01-01/2010-12-31?unitGroup=metric&include=days%2Cevents&key=87T6FUFEU3JP8VEAKVQURPEVB&contentType=json")

# Parse the results as JSON
jsonData = response_10.json()
print(jsonData)

# Convert the JSON data to a Pandas DataFrame
Cali_2010 = pd.DataFrame(jsonData['days'])

Cali_2010.to_csv('../data/raw-data/Cali_2010.csv', index=False)

response_01 = requests.request("GET", "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/california/2001-01-01/2001-12-31?unitGroup=metric&include=days%2Cevents&key=87T6FUFEU3JP8VEAKVQURPEVB&contentType=json")

# Parse the results as JSON
jsonData = response_01.json()
print(jsonData)

# Convert the JSON data to a Pandas DataFrame
Cali_2001 = pd.DataFrame(jsonData['days'])

Cali_2001.to_csv('../data/raw-data/Cali_2001.csv', index=False)




