library(shinydashboard)
library(leaflet)

server <- function(input, output) {
  output$carte <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron")
  })
}
