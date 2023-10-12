library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
HumanCausedAcres <- read_csv("data/raw-data/HumanCausedAcres.csv")
HumanCausedFires <- read_csv("data/raw-data/HumanCausedFires.csv")
LighteningAcres <- read_csv("data/raw-data/LighteningAcres.csv")
LightingFires <- read_csv("data/raw-data/LightingFires.csv")
SuppCosts <- read_csv("data/raw-data/SuppCosts.csv")
head(SuppCosts)
# Subset a data frame with the given column names:
HumanCausedAcres <- HumanCausedAcres[, c("Year", "Northern California", 
                                         "Southern California", "Total")]
head(HumanCausedAcres)
# Create a new column California_Acres, which is the sum of the column Northern California` and column `Southern California`
HumanCausedAcres$California_Acres <- HumanCausedAcres$`Northern California` +
  HumanCausedAcres$`Southern California`
# Remove the column Northern California` and column `Southern California`
HumanCausedAcres <- subset(HumanCausedAcres, select = -c(`Northern California`, 
                                                         `Southern California`))
head(HumanCausedAcres)
# Rename the column Total
HumanCausedAcres <- HumanCausedAcres %>%
  rename(Total_Acres = Total)
# Switch the order of the two columns
HumanCausedAcres <- HumanCausedAcres[, c("Year", "California_Acres", "Total_Acres")]
head(HumanCausedAcres)

# Do the same for the rest of the data frames
HumanCausedFires <- HumanCausedFires[, c("Year", "Northern California",
                                         "Southern California", "Total")]
LighteningAcres <- LighteningAcres[, c("Year", "Northern California",
                                       "Southern California", "Total")]
LightingFires <- LightingFires[, c("Year", "Northern California",
                                   "Southern California", "Total")]
SuppCosts <- SuppCosts[, c("Year", "Fires", "Acres", "Total")]

HumanCausedFires$California_Fires <- HumanCausedFires$`Northern California` +
  HumanCausedFires$`Southern California`
HumanCausedFires <- subset(HumanCausedFires, select = -c(`Northern California`, 
                                                         `Southern California`))
HumanCausedFires <- HumanCausedFires %>%
  rename(Total_Fires = Total)
HumanCausedFires <- HumanCausedFires[, c("Year", "California_Fires", "Total_Fires")]

LighteningAcres$California_Acres <- LighteningAcres$`Northern California` +
  LighteningAcres$`Southern California`
LighteningAcres <- subset(LighteningAcres, select = -c(`Northern California`, 
                                                       `Southern California`))
LighteningAcres <- LighteningAcres %>%
  rename(Total_Acres = Total)
LighteningAcres <- LighteningAcres[, c("Year", "California_Acres", "Total_Acres")]

LightingFires$California_Fires <- LightingFires$`Northern California` +
  LightingFires$`Southern California`
LightingFires <- subset(LightingFires, select = -c(`Northern California`, 
                                                   `Southern California`))
LightingFires <- LightingFires %>%
  rename(Total_Fires = Total)
LightingFires <- LightingFires[, c("Year", "California_Fires", "Total_Fires")]


# Merging the two data frame with respect to Year
HumanCaused <- merge(HumanCausedAcres, HumanCausedFires, by = "Year", all = TRUE)
LighteningCaused <- merge(LighteningAcres, LightingFires, by = "Year", all = TRUE)

head(HumanCaused)
head(LighteningCaused)
# Rename the columns
HumanCaused <- HumanCaused %>%
  rename(Cali_Acres_H = California_Acres,
         Total_Acres_H = Total_Acres, 
         Cali_Fires_H = California_Fires,
         Total_Fires_H = Total_Fires)

LighteningCaused <- LighteningCaused %>%
  rename(Cali_Acres_L = California_Acres,
         Total_Acres_L = Total_Acres, 
         Cali_Fires_L = California_Fires,
         Total_Fires_L = Total_Fires)

head(HumanCaused)
head(LighteningCaused)

Human_Lightening <- merge(HumanCaused, LighteningCaused, by = "Year", all = TRUE)

# Assuming your data frame is called Human_Lightening
Human_Lightening <- Human_Lightening %>%
  pivot_longer(cols = -Year, names_to = "Variable") %>%
  mutate(
    Cause = ifelse(grepl("_H$", Variable), "Human", "Lightning"),
    Variable = gsub("_H$|_L$", "", Variable)
  ) %>%
  pivot_wider(names_from = Variable, values_from = value)

# Save Human_Lightening data to a CSV file
write.csv(Human_Lightening, file = "data/cleaned-data/Human_Lightening.csv", row.names = FALSE)

# Clean up the SuppCosts data set
# Remove the rows below index 38
SuppCosts <- SuppCosts[(1:38), ]

# Convert Acres and Total columns to numeric (remove commas and dollar signs)
SuppCosts$Acres <- as.numeric(gsub(",", "", SuppCosts$Acres))
SuppCosts$Total <- as.numeric(gsub("\\$", "", gsub(",", "", SuppCosts$Total)))

# Rename
SuppCosts <- SuppCosts  %>%
  rename(Total_spent = Total)

# Calculate a combined score based on Fires and Acres
SuppCosts$CombinedScore <- SuppCosts$Fires + SuppCosts$Acres

# Sort the data based on the combined score in descending order
sorted_SuppCosts <- SuppCosts[order(-SuppCosts$CombinedScore), ]

write.csv(sorted_SuppCosts, file = "data/cleaned-data/sorted_SuppCosts.csv", row.names = FALSE)


Cali_2020 <- read_csv("data/raw-data/Cali_2020.csv")
# Subset a data frame with the given column names:
Cali_2020 <- Cali_2020[ , c('datetime', 'tempmax', 'tempmin', 'humidity', 
                            'precip', 'windspeed')]

Cali_2017 <- read_csv("data/raw-data/Cali_2017.csv")
Cali_2017 <- Cali_2017[ , c('datetime', 'tempmax', 'tempmin', 'humidity', 
                            'precip', 'windspeed')]

Cali_2015 <- read_csv("data/raw-data/Cali_2015.csv")
Cali_2015 <- Cali_2015[ , c('datetime', 'tempmax', 'tempmin', 'humidity', 
                            'precip', 'windspeed')]

Cali_2014 <- read_csv("data/raw-data/Cali_2014.csv")
Cali_2014 <- Cali_2014[ , c('datetime', 'tempmax', 'tempmin', 'humidity', 
                            'precip', 'windspeed')]

Cali_2010 <- read_csv("data/raw-data/Cali_2010.csv")
Cali_2010 <- Cali_2010[ , c('datetime', 'tempmax', 'tempmin', 'humidity', 
                            'precip', 'windspeed')]

Cali_2001 <- read_csv("data/raw-data/Cali_2001.csv")
Cali_2001 <- Cali_2001[ , c('datetime', 'tempmax', 'tempmin', 'humidity', 
                            'precip', 'windspeed')]

write.csv(Cali_2020, file = "data/cleaned-data/Cali_2020.csv", row.names = FALSE)
write.csv(Cali_2017, file = "data/cleaned-data/Cali_2017.csv", row.names = FALSE)
write.csv(Cali_2015, file = "data/cleaned-data/Cali_2015.csv", row.names = FALSE)
write.csv(Cali_2014, file = "data/cleaned-data/Cali_2014.csv", row.names = FALSE)
write.csv(Cali_2010, file = "data/cleaned-data/Cali_2010.csv", row.names = FALSE)
write.csv(Cali_2001, file = "data/cleaned-data/Cali_2001.csv", row.names = FALSE)


Cali_MDY <- read_csv("data/raw-data/Cali_MDY.csv")
Cali_MDY <- Cali_MDY %>%
  rename(
    AcresBurned = `Acres Burned`
  )
Cali_MDY <- Cali_MDY[ , c('StartDate', 'AcresBurned', 'Cause', 
                          'StructureDest.', 'StructureDam.', 
                          'FirePersonnelDeath', 'CivilDeath')]

# Replace NA values with 0 in the columns
Cali_MDY$StructureDest.[is.na(Cali_MDY$StructureDest.)] <- 0
Cali_MDY$StructureDam.[is.na(Cali_MDY$StructureDam.)] <- 0
Cali_MDY$FirePersonnelDeath[is.na(Cali_MDY$FirePersonnelDeath)] <- 0
Cali_MDY$CivilDeath[is.na(Cali_MDY$CivilDeath)] <- 0

# Add up 'StructureDest.' and 'StructureDam.' and name the new column 'StructureDam'
Cali_MDY$StructureDam <- Cali_MDY$StructureDest. + Cali_MDY$StructureDam.

# Add up 'FirePersonnelDeath' and 'CivilDeath' and name the new column 'Fatalities'
Cali_MDY$Fatalities <- Cali_MDY$FirePersonnelDeath + Cali_MDY$CivilDeath

# Delete the original four columns
Cali_MDY <- Cali_MDY[, !names(Cali_MDY) %in% c('StructureDest.', 'StructureDam.', 'FirePersonnelDeath', 'CivilDeath')]

# Identify NA values in the StartDate column
na_rows <- is.na(Cali_MDY$StartDate)

# Convert date column to Date format
Cali_MDY$StartDate <- as.Date(Cali_MDY$StartDate, format = "%m/%d/%y")

# Remove rows with NA values in the StartDate column
Cali_MDY <- Cali_MDY[!na_rows, ]

# Left merge the two datasets based on the 'datetime' and 'StartDate' columns
Cali20_climate_fire <- merge(Cali_2020, Cali_MDY, by.x = "datetime", by.y = "StartDate", all.x = TRUE)

# Create a new column 'fire' based on the 'AcresBurned' column
Cali20_climate_fire$fire <- ifelse(!is.na(Cali20_climate_fire$AcresBurned), "Yes", "No")

write.csv(Cali20_climate_fire, file = "data/cleaned-data/Cali20_climate_fire.csv", row.names = FALSE)





