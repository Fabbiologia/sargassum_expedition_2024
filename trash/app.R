library(tidyverse)
library(shiny)
library(leaflet)
library(readxl)
library(sf)
library(leaflet.extras)  


data <- readxl::read_xlsx("Expedition_plan.xlsx", sheet = 2) %>%
     filter(!is.na(Latitude))

airports <- st_read("ne_10m_airports/GOC_airports.shp")

ui <- fluidPage(
     titlePanel("25th Anniversary \n Long-Term Ecological Monitoring Expedition 2023"),
          # Main panel for the leaflet map
               leafletOutput("map", width = "100%", height = "800px")  
     )




airportIcon <- makeAwesomeIcon(
     icon = "fa-plane",
     library = "fa"
)

server <- function(input, output) {
     
     # Create the leaflet map
     output$map <- renderLeaflet({
          leaflet() %>%
               addProviderTiles("Esri.WorldImagery", group = "Esri.WorldImagery") %>%
               addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron") %>%
               setView(lng = -110.60, lat = 26, zoom = 7) # Set initial map view coordinates
     })
     
     # Add points with different colors for each work week
     observe({
          colors <- c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3", "#ff7f00", "#ffff33", "#a65628", "#f781bf", "#999999", "#a6cee3", "#b2df8a", "#cab2d6")
          wk_levels <- levels(as.factor(data$Wk))
          layer_names <- vector("list", length(wk_levels))
          
          for(i in seq_along(wk_levels)) {
               data_week <- data[data$Wk == wk_levels[i],]
               
               layer_names[[i]] <- sprintf('<text style="color: %s">Week %s</text>', colors[i], wk_levels[i])
               
               
               leafletProxy("map") %>%
                    addCircleMarkers(
                         data = data_week,
                         lng = ~Longitude,
                         lat = ~Latitude,
                         color = colors[i],
                         fillOpacity = 0.8,
                         radius = 6,
                         group = layer_names[[i]],  # Add group for each week layer
                         popup = paste0(
                              "<b>Date:</b> ", data_week$Date, "<br>",
                              "<b>Week:</b> ", data_week$Wk, "<br>", 
                              "<b>Time expected:</b> ", data_week$Time, "<br>"
                         )
                    ) 
               leafletProxy("map") %>%
                    addLayersControl(
                         overlayGroups = layer_names,
                         options = layersControlOptions(collapsed = FALSE),
                         baseGroups = c("Esri.WorldImagery", "CartoDB.Positron")
                         
                    )
               }
     })

     
     # Add airports layer
     observe({
          leafletProxy("map") %>%
               addAwesomeMarkers(
                    data = airports,
                    icon = airportIcon,
                    popup = ~paste(
                         "<b>Airport:</b> ", name, "<br>"
                    )
               )
     })
}

# Run the Shiny app
shinyApp(ui, server)
