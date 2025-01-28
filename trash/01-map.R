library(tidyverse)
library(sf)

sar_biom_alf <- read_csv("sargassum_biomass.csv")


sar_biom_sf <- st_as_sf(sar_biom_alf, coords = c("long", "lat"), crs = 4326, remove = F)


mapview::mapview(sar_biom_sf)

sar_alvin <- readxl::read_xlsx("Sargazo_Biomasa.xlsx")%>% 
     janitor::clean_names()




sar_alvin <- st_as_sf(sar_alvin, coords = c("decimal_longitude_w", "decimal_latitude_n"), crs = 4326, remove = F)


mapview::mapview(sar_alvin, zcol = "biomasa2")
