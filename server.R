server <- function(input, output, session) {
  
  # ------ Track displayed markers ---------------------------------------------
  displayed_markers <- reactiveVal(NULL)
  
  # ------ Initial map setup with all markers ---------------------------------
  output$map <- renderLeaflet({
    # Display all markers at the start
    displayed_markers(cycle_hire_dt$id)
    
    leaflet(cycle_hire_dt) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      # Add initial layers for bikes and empty docks
      addCircleMarkers(
        lng = ~lon, lat = ~lat,
        layerId = ~paste0("nbikes", id),
        group = "nbikes",
        color = ~color_palette_nbikes(nbikes),
        radius = 9,
        fillOpacity = 0.6,
        popup = ~generate_popup(name, area, nbikes, nempty)
      ) %>%
      addCircleMarkers(
        lng = ~lon, lat = ~lat,
        layerId = ~paste0("nempty", id),
        group = "nempty",
        color = ~color_palette_nempty(nempty),
        radius = 9,
        fillOpacity = 0.6,
        popup = ~generate_popup(name, area, nbikes, nempty)
      )
  })
  
  # ------ Update map markers according to the color_by input ------------------
  # using the 'group' marker attribute
  observeEvent(input$color_by, {
    # toggle the visibility of the markers by group
    leafletProxy("map") %>%
      hideGroup(ifelse(input$color_by == "nbikes", "nempty", "nbikes")) %>%
      showGroup(input$color_by) %>% 
      # Update the legend
      clearControls() %>%
      addLegend(
        position = "bottomright",
        pal = if (input$color_by == "nbikes") color_palette_nbikes else color_palette_nempty,
        values = if (input$color_by == "nbikes") cycle_hire_dt$nbikes else cycle_hire_dt$nempty,
        title = if (input$color_by == "nbikes") "Bikes Available" else "Empty Docks",
        opacity = 0.7
      )
  })
  
  # ------ Update markers according to the min_nbikes --------------------------
  # using the 'layerId' marker attribute
  observeEvent(input$min_bikes, {
    # Filter data for stations meeting the minimum bike criteria
    valid_stations <- cycle_hire_dt[nbikes >= input$min_bikes]
    
    # Current and required marker IDs
    current_ids <- displayed_markers()
    required_ids <- valid_stations$id
    
    # Determine which markers to add or remove
    remove_ids <- setdiff(current_ids, required_ids)
    add_ids <- setdiff(required_ids, current_ids)
    
    # Update the reactive value with the new displayed marker IDs
    displayed_markers(required_ids)
    
    # Remove markers 
    if (length(remove_ids) > 0) {
      leafletProxy("map") %>%
        removeMarker(layerId = paste0("nbikes", remove_ids)) %>%
        removeMarker(layerId = paste0("nempty", remove_ids))
    }
    
    # Add new markers
    if (length(add_ids) > 0) {
      new_markers <- valid_stations[id %in% add_ids]
      leafletProxy("map") %>%
        addCircleMarkers(
          lng = new_markers$lon, 
          lat = new_markers$lat,
          layerId = paste0("nempty", new_markers$id),
          group = "nempty",
          color = color_palette_nempty(new_markers$nempty),
          radius = 9,
          fillOpacity = 0.6,
          popup = generate_popup(
            new_markers$name, new_markers$area, new_markers$nbikes, new_markers$nempty
          )
        ) %>% 
        addCircleMarkers(
          lng = new_markers$lon, 
          lat = new_markers$lat,
          layerId = paste0("nbikes", new_markers$id),
          group = "nbikes",
          color = color_palette_nbikes(new_markers$nbikes),
          radius = 9,
          fillOpacity = 0.6,
          popup = generate_popup(
            new_markers$name, new_markers$area, new_markers$nbikes, new_markers$nempty
          )
        )
    }
  })
}
