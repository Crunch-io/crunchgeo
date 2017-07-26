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
    # TODO: move to new topo/geo API descriptor instead of file extension guess
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

#' Get a CrunchDataFrame inside of a SpatialDataFrame
#'
#' @param geo_var the alias of the variable that has geodata associated with it
#' @param data a Crunch dataset object
#' @param ... passed to `fetchGeoFile`
#'
#' @return a SpatialDataFrame with a CrunchDataFrame in the `Data` slot instead
#' of a standard data.frame
#'
#' @export
getGeoDataFrame <- function(geo_var, data, ...) {
    # todo: accept geo_var as var
    if(!inherits(data, "CrunchDataset")){
        halt("The data object (", dQuote(substitute(data)), ") is not a Crunch dataset.")
    }
    if(!geo_var %in% names(data)){
        halt("The geo_var object (", dQuote(geo_var), ") is not a variable in the dataset provided.")
    }

    crunch_geo <- geo(data[[geo_var]])
    if(!inherits(crunch_geo, "CrunchGeography")){
        halt("The geo_var (", dQuote(geo_var), ") does not have any geographic metadata associated with it. Please contact support@crunch.io for help associating geographic metadata.")
    }

    geodata <- fetchGeoFile(crunch_geo, ...)

    crunch_df <- as.data.frame(data)
    geodata@data <- merge(crunch_df, geodata@data,
                          by.x = geo_var,
                          by.y= gsub("properties.", "", crunch_geo$feature_key),
                          sort = "y")
    return(geodata)
}
