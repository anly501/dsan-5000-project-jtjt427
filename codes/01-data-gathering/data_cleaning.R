library(readr)
library(dplyr)
HumanCausedAcres <- read_csv("data/raw-data/HumanCausedAcres.csv")
HumanCausedFires <- read_csv("data/raw-data/HumanCausedFires.csv")
LighteningAcres <- read_csv("data/raw-data/LighteningAcres.csv")
LightingFires <- read_csv("data/raw-data/LightingFires.csv")
SuppCosts <- read_csv("data/raw-data/SuppCosts.csv")

# Subset a data frame with the given column names:
HumanCausedAcres <- HumanCausedAcres[, c("Year", "Northern California", 
                                         "Southern California", "Total")]
HumanCausedFires <- HumanCausedFires[, c("Year", "Northern California",
                                         "Southern California", "Total")]
LighteningAcres <- LighteningAcres[, c("Year", "Northern California",
                                       "Southern California", "Total")]
LightingFires <- LightingFires[, c("Year", "Northern California",
                                   "Southern California", "Total")]
SuppCosts <- SuppCosts[, c("Year", "Fires", "Acres", "Total")]

# Create a new column California_Acres, which is the sum of the column Northern California` and column `Southern California`
HumanCausedAcres$California_Acres <- HumanCausedAcres$`Northern California` +
  HumanCausedAcres$`Southern California`

# Remove the column Northern California` and column `Southern California`
HumanCausedAcres <- subset(HumanCausedAcres, select = -c(`Northern California`, 
                                                         `Southern California`))

# Rename the column Total
HumanCausedAcres <- HumanCausedAcres %>%
  rename(Total_Acres = Total)

# Switch the order of the two columns
HumanCausedAcres <- HumanCausedAcres[, c("Year", "California_Acres", "Total_Acres")]

# Do the same for the rest of the data frames
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

Human_Lightening <- merge(HumanCaused, LighteningCaused, by = "Year", all = TRUE)

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







