#' Helper for creating leaflet labels on mouse over
#'
#' This function creates the html necesary for making labels in leaflet. It is
#'  vectorized so you can provide it with vectors of titles, items, and values
#'  and it will make one label for each (so that each region on a map has it's
#'  own hover over, for example)
#'
#' @param title the title of the hover over
#' @param item  the item that is bein displayed?
#' @param value the value to be displayed (currently ends with a percent sign)
#'
#' @return list of html widgets, one for each title, item, value.
#'
#'
#' @export
leaflet_hover <- Vectorize(function(title, item, value) {
    # TODO: allow for multiple item, value pairs so that there can be more than
    # one value per label
    htmltools::HTML(
        sprintf(
            "<div style='font-size:12px;float:left'>
            <span style='font-size:18px;font-weight:bold'>%s</span>
            </br>
            <span style='font-size:14px'>%s %s%%</span>
            </div>",
            title, item, round(value, 3)
        )
    )
}, vectorize.args = c("title", "item", "value"), SIMPLIFY = FALSE)
