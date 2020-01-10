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
#' @importFrom methods slot slot<-
#' @import crunch
#' @rdname fetchGeoFile
#' @export
setMethod("fetchGeoFile", "CrunchGeography", function(geography, ...){
    gd <- Geodata(crGET(geography$geodatum))
    # check if gotten?
    url <- gd$location
    frmt <- gd$format
    ext <- file_ext(url)
    if (frmt != "notjson" && !identical(frmt, ext)) {
        halt("CrunchGeograpy's format (", dQuote(frmt), ") must match ",
             "file extension of url (", dQuote(url), ")")
    }
    
    if (frmt == "topojson") {
        geo_data <- as(topojson_read(url, ...), "Spatial")
    } else if (frmt %in% c("geojson", "json")) {
        geo_data <- geojson_read(url, what = "sp", ...)
    } else {
        halt("Unknown format ", dQuote(frmt), " in geodata url: ", url)
    }

    return(geo_data)
})

#' @rdname fetchGeoFile
#' @importFrom crunch geo
setMethod("fetchGeoFile", "CrunchVariable", function (geography, ...) {
    fetchGeoFile(geo(geography, ...))
})

#' @rdname fetchGeoFile
setMethod("fetchGeoFile", "ANY", function(geography, ...) {
    halt("Cannot fetch a geography on objects other than CrunchGeography" ,
         " or CrunchVaraibles.")
})


#' Get a CrunchDataFrame inside of a SpatialDataFrame
#'
#' The `sp` package has a number of classes of SpatialXDataFrames like SpatialPolygonDataFrame. These include both data.frame content (in their `@data` slot) as well as the spatial information (polygons, points, etc.; in their `@polygons`, `@points`, etc. slots). This function replaces the data.frame that would normally come from the topo- or geo-json with a CrunchDataFrame that includes all of the same information as the original data.frame, but also with information about the CrunchDataSet (similar to using `as.data.frame(dataset)`).
#'
#' @param geo_var the alias of the variable that has geodata associated with it
#' @param data a Crunch dataset object
#' @param ... passed to `fetchGeoFile`
#'
#' @return a SpatialDataFrame with a CrunchDataFrame in the `Data` slot instead
#' of a standard data.frame
#'
#' @examples
#' \dontrun{
#' library(leaflet)
#' ds_geodata <- getGeoDataFrame("state", ds)
#'
#' # a very simple leaflet choropleth
#' pal <- colorNumeric(
#' palette = "viridis",
#' domain = ds_geodata$turnout)
#'
#' leaflet(ds_geodata) %>%
#'     addPolygons(color = "#444444", weight = 0.5, smoothFactor = 0.5,
#'                 opacity = 0.75, fillOpacity = 0.85,
#'                 fillColor = ~pal(turnout))
#' }
#'
#' @export
getGeoDataFrame <- function(geo_var, data, ...) {
    # todo: accept geo_var as var
    if(!inherits(data, "CrunchDataset")){
        halt("The data object (", dQuote(substitute(data)), ") is not a ",
             "Crunch dataset.")
    }
    if(!geo_var %in% names(data)){
        halt("The geo_var object (", dQuote(geo_var), ") is not a variable in",
             " the dataset provided.")
    }

    crunch_geo <- geo(data[[geo_var]])
    if(!inherits(crunch_geo, "CrunchGeography")){
        halt("The geo_var (", dQuote(geo_var), ") does not have any ",
             "geographic metadata associated with it. Please contact",
             " support@crunch.io for help associating geographic metadata.")
    }

    geodata <- fetchGeoFile(crunch_geo, ...)

    crunch_df <- as.data.frame(data)
    merged_df <- merge(crunch_df, geodata@data,
                          by.x = geo_var,
                          by.y= gsub("properties.", "", crunch_geo$feature_key),
                          sort = "y")
    # don't check the class of data because it is a CrunchDataFrame, not a data.frame
    slot(geodata, "data", check = FALSE) <- merged_df
    return(geodata)
}
