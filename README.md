### Optimizing Leaflet

1. **Separation of Map Initialization and Updates**:  
   - The rendering function `renderLeaflet()` is triggered once for the static initial setup of the map during app launch, while `leafletProxy()` handles dynamic updates via observers. This separation improves performance by avoiding a complete map re-render for each change.

2. **Targeted Marker Updates**:  
   - Each marker is uniquely identified using `layerId`, enabling precise control over the displayed markers.  
   - The reactive variable`displayed_markers()` keeps track of the currently visible markers to avoid unnecessary marker re-rendering.
   - When `input$min_bikes` updates, only the necessary markers are added or removed. This Ensures faster updates and smoother responsiveness, even for large data sets.

3. **Grouped Updates**:  
   - Between the two categories `nbikes` and `nempty`, Markers are organized into groups, using the marker `group` attribute. Their visibility is then dynamically toggled using `hideGroup()` and `showGroup()` based on the selected option in `input$color_by`. This approach enables efficient switching between different coloring parameters, e.g., the number of bikes available or the number of empty docks.
   