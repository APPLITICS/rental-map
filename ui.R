ui <- fluidPage(
  # ------ Scripts & styles ----------------------------------------------------
  includeCSS("www/css/app.min.css"), # App style
  
  class = "fullscreen-map",
  
  # ------ Map -----------------------------------------------------------------
  leafletOutput("map", width = "100%", height = "100vh"),
  
  # ------ Control panel -------------------------------------------------------
  absolutePanel(
    class = "control-panel",
    radioButtons(
      inputId = "color_by",
      label = "Color markers by:",
      choices = c("Bikes Available" = "nbikes", "Empty Docks" = "nempty"),
      selected = "nbikes"
    ),
    sliderInput(
      inputId = "min_bikes",
      label = "Minimum bikes available:",
      min = 0,
      max = max(cycle_hire_dt$nbikes, na.rm = TRUE),
      value = 0,
      step = 1
    )
  )
)
