library(sf)
library(dplyr)
library(readr)

# Set path
setwd("C:/Users/32788/OneDrive - University College London/0005GIS")

# Read the data
gender_data <- read_csv("Composite_indices_complete_time_series (1).csv")
world_data <- st_read("World_Countries_(Generalized)_9029012925078512962.geojson")

# Extract GII data from 2010 to 2019
gii_data <- gender_data %>%
  select(COUNTRY = country,  
         gii_2010,
         gii_2019) %>%
  mutate(GII_Diff = gii_2019 - gii_2010)

# Preview the new GII data from 2010 to 2019
print(head(gii_data))

# Check again
print(sum(is.na(gii_data$GII_Diff)))

# Join the GII data with spatial data
merged_data <- world_data %>%
  left_join(gii_data, by = "COUNTRY")

# Check the structure of the merged data
print(head(merged_data))

# Save as GeoJSON
st_write(merged_data, 
         "World_Gender_Inequality_Diff.geojson", 
         delete_dsn = TRUE)

# Create a global map to show the data
if(require(ggplot2)) {
  ggplot(data = merged_data) +
    geom_sf(aes(fill = GII_Diff)) +
    scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                         midpoint = 0,
                         name = "GII Difference\n(2019-2010)") +
    theme_minimal() +
    ggtitle("Change in Gender Inequality Index (2010-2019)")
}

# Print summary statistics
cat("\nSummary of GII Differences:\n")
print(summary(merged_data$GII_Diff))

# Print the number of countries with data
cat("\nNumber of countries with GII difference data:", 
    sum(!is.na(merged_data$GII_Diff)))
