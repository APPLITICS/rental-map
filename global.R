# Load necessary libraries
library(shiny)
library(leaflet)
library(leaflet.extras)
library(spData)
library(data.table)

# Prepare the cycle_hire dataset
cycle_hire_dt <- sf::st_as_sf(cycle_hire)  # Convert to sf object
cycle_hire_dt <- data.table(cycle_hire_dt)  # Convert to data.table for efficiency
cycle_hire_dt[, c("lon", "lat") := as.data.table(sf::st_coordinates(geometry))][
  , geometry := NULL
]

# Define color palette
color_palette_nbikes <- colorNumeric("Reds", domain = cycle_hire_dt$nbikes)
color_palette_nempty <- colorNumeric(palette = "Blues", domain = cycle_hire_dt$nempty)