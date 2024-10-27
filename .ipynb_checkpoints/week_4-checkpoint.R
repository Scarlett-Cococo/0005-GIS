install.packages(c("sf", "dplyr", "readxl", "tidyverse"))

library(sf)
library(dplyr)
library(readxl)
library(tidyverse)

# Set pathes for both files
geojson_path <- "C:/Users/32788/OneDrive - University College London/0005GIS/World_Countries_(Generalized)_9029012925078512962.geojson"
excel_path <- "C:/Users/32788/OneDrive - University College London/0005GIS/HDR23-24_Statistical_Annex_GII_Table.xlsx"

# Load datas
world_data <- st_read(geojson_path)
gender_data <- read_excel(excel_path, sheet = 1)

# Inspect the data to find relevant columns
glimpse(gender_data)

# Filter and clean gender inequality data for necessary columns and years (2010 and 2019)
# Assuming columns have names like "Country", "GII_2010", "GII_2019" for Gender Inequality Index values in 2010 and 2019.
gender_data <- gender_data %>%
  select(Country = `Country Column`, GII_2010 = `GII 2010 Column`, GII_2019 = `GII 2019 Column`) %>%
  mutate(GII_Diff = GII_2019 - GII_2010)

# Join the gender inequality data with the world spatial data
# Ensure there is a common column between the two datasets, here assumed as "Country" for gender_data and "NAME" for world_data
merged_data <- world_data %>%
  left_join(gender_data, by = c("NAME" = "Country"))

# Check if the data joined successfully and GII_Diff was calculated
glimpse(merged_data)

# Save the merged data to a new .geojson file for sharing on GitHub
output_geojson_path <- "C:/Users/32788/OneDrive - University College London/0005GIS/Github/0005-GIS/World_Gender_Inequality_Diff.geojson"
st_write(merged_data, output_geojson_path, delete_dsn = TRUE)

# Print confirmation message
cat("The merged data with gender inequality differences has been saved to:", output_geojson_path)
