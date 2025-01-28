# Define the function to load, convert, and save
convert_excel_to_geojson <- function(input_file, lat_col, lon_col, output_file) {
    # Step 1: Load the Excel file
    data <- read_csv(input_file)

    # Step 2: Check if latitude and longitude columns exist
    if (!(lat_col %in% colnames(data) && lon_col %in% colnames(data))) {
        stop("Latitude or longitude columns not found in the input file.")
    }

    # Step 3: Remove rows with missing latitude or longitude
    data <- data[!is.na(data[[lat_col]]) & !is.na(data[[lon_col]]), ]

    # Check if any data remains after removing missing values
    if (nrow(data) == 0) {
        stop("No valid rows remain after removing rows with missing coordinates.")
    }

    # Step 4: Convert the data to an sf object
    sf_object <- st_as_sf(
        data,
        coords = c(lon_col, lat_col), # Longitude first, then latitude
        crs = 4326, # WGS 84 coordinate system
        remove = FALSE # Retain the original coordinates in the table
    )

    # Step 5: Save the sf object as a GeoJSON file
    st_write(sf_object, output_file, driver = "GeoJSON", delete_dsn = TRUE)

    message("GeoJSON file saved to: ", output_file)
}
library(tidyverse)
# Example Usage
# Replace with your file path, sheet name, and column names
input_excel_file <- "sargassum_coordinates.csv" # Input Excel file

latitude_column <- "Latitude" # Name of the latitude column
longitude_column <- "Longitude" # Name of the longitude column
output_geojson_file <- "output_data.geojson" # Output GeoJSON file

# Run the function
convert_excel_to_geojson(
    input_file = input_excel_file,
    lat_col = latitude_column,
    lon_col = longitude_column,
    output_file = output_geojson_file
)
git remote add origin https://github.com/Fabbiologia/sargassum_expedition_2024.git
git add .
git commit -m "Initial commit"