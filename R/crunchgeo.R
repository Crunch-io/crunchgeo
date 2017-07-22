# Here's a good place to put your top-level package documentation

.onAttach <- function (lib, pkgname="crunchgeo") {
    ## Put stuff here you want to run when your package is loaded
    invisible()
}

#' @rdname fetchGeoFile
setGeneric("fetchGeoFile", function (geography, ...) standardGeneric("fetchGeoFile"))


#' Fetch a geo- or topo-json hosted by Crunch
#'
#' @param geography a `CrunchGeography` object, generally obtained by using the `geo`
#'  function on a dataset variable that has geography data specified.
#' @param ... additional options to pass to `geojson_read` or `topojson_read`
#'
#' @examples
#' \dontrun{
#' geo_data <- fetchGeoFile(geo(ds$country))
#' }
#'
#' @importFrom tools file_ext
#' @importFrom httpcache halt
#' @importFrom geojsonio geojson_read topojson_read
#' @import crunch
#' @rdname fetchGeoFile
#' @export
setMethod("fetchGeoFile", "CrunchGeography", function(geography, ...){
    url <- geography$geodatum$location
    fileext <- file_ext(url)
    if (fileext == "topojson") {
        geo_data <- topojson_read(url, ...)
    } else if (fileext %in% c("geojson", "json")) {
            geo_data <- geojson_read(url, ...)
        } else {
                halt("Unknown filetype ", dQuote(fileext), " in geodata url: ", url)
            }

    return(geo_data)
})
