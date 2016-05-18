library(shinydashboard)
library(leaflet)

ui <- dashboardPage(
  dashboardHeader(title = "Carnet de bord"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Carte", tabName = "carte", icon = icon("globe")),
      menuItem("Budget", tabName = "budget", icon = icon("money")),
      menuItem("Planning", tabName = "planning", icon = icon("calendar"))
    )
  ),
  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "carte",
              box(leafletOutput("carte", width = "100%", height = "600px"), width = "100%")
      ),

      # Second tab content
      tabItem(tabName = "budget",
              h2("Widgets tab content")
      )
    )
  )
)
