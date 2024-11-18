#' Generate Marker Popups for Leaflet Map
#' Creates an HTML string for a popup displaying station details in a Leaflet map.#'
#' @param name A string representing the name of the station.
#' @param area A string representing the area of the station.
#' @param nbikes An integer or numeric value representing the number of bikes available.
#' @param nempty An integer or numeric value representing the number of empty docks.
#' @return A string containing the formatted HTML for the popup.
generate_popup <- function(name, area, nbikes, nempty) {
  paste(
    "<b>Station:</b>", name,
    "<br><b>Area:</b>", area,
    "<br><b>Bikes Available:</b>", nbikes,
    "<br><b>Empty Docks:</b>", nempty
  )
}
