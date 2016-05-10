library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(title = "Carnet de bord"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Carte", tabName = "carte", icon = icon("globe")),
      menuItem("Budget", tabName = "budget", icon = icon("money"))
    )
  ),
  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "carte",
              fluidRow(
                box(plotOutput("plot1", height = 250)),

                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )
      ),

      # Second tab content
      tabItem(tabName = "budget",
              h2("Widgets tab content")
      )
    )
  )
)
