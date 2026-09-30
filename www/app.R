
#Shiny web application.
getwd()
install.packages("shiny")
library(shiny)
library(leaflet)
library(readxl)
library(dplyr)
install.packages("tidygeocoder")
library(tidygeocoder)
install.packages ("shinyWidgets")
library(shinyWidgets)
install.packages("leaflet.extras")
library(leaflet.extras)
# only needed if you want address search

ui <- fluidPage(
  titlePanel("Pinellas County Coral Map"),
    mainPanel(
      leafletOutput("map", height = 600)
    )
  )


server <- function(input, output, session) {
  
  # excel data in map
  map_data<-Coral_Locations_Tracking%>%
    select(Address,Latitude,Longitude,WND,Species)%>%
    mutate(Address = as.character(Address))
  
  # coral icon from coral code.r
  coralIcon <- makeIcon(
    iconUrl = "https://static.vecteezy.com/system/resources/previews/016/548/438/large_2x/watercolor-sea-coral-png.png",
    iconWidth = 30, iconHeight = 30,
    iconAnchorX = 0, iconAnchorY = 0,
    shadowUrl = "https://static.vecteezy.com/system/resources/previews/016/548/438/large_2x/watercolor-sea-coral-png.png",
    shadowWidth = 20, shadowHeight = 20,
    shadowAnchorX = 0, shadowAnchorY = 0
  )
  
  # Rendering initial map code from coral code.r
  output$map <- renderLeaflet({
    leaflet(data = map_data) %>%
      addProviderTiles("Esri.WorldImagery") %>%
      addMarkers(
        lng = ~Longitude,
        lat = ~Latitude,
        icon = coralIcon,
        popup = ~paste0("<b>", Address, "</b><br>", WND, "<br>", Species),
        group = "searchAddress",
        label= ~Address
      ) %>%
      addSearchFeatures(
        targetGroups = "searchAddress",
        options = searchFeaturesOptions(
          zoom = 12,
          openPopup = TRUE,
          position="topleft"
        )
      )
  })
}
 
shinyApp(ui, server)


