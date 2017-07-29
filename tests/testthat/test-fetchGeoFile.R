context("fetchGeoFile methods")

with_mock_crunch({
    ds <- loadDataset("test ds")
    geo_data <- geo(ds$location)

    test_that("fetchGeoFile", {
        test_crGeo <- list(
            geodatum = Geodata(crGET("https://app.crunch.io/api/geodata/newone/")),
            feature_key = "none",
            match_field = "none")
        test_crGeo <- new("CrunchGeography", test_crGeo)
        # topojson_read() doesn't result in a get because it reads directly through readOGR in the geojsonio
        expect_GET(fetchGeoFile(geo_data),
                     'https://s.crunch.io/some/wrong/gb_eer_doesnotexist.topojson')
        expect_GET(fetchGeoFile(test_crGeo),
                   'https://s.crunch.io/some/wrong/path.geojson')
        test_crGeo$geodatum$format <- "notjson"
        expect_error(fetchGeoFile(test_crGeo), "Unknown format ", dQuote("notjson"), " in geodata url: ", "https://s.crunch.io/some/wrong/path.geojson")
    })

    test_that("fetchGeoFile works with other arguments", {
        expect_error(fetchGeoFile("foo"),
                     "Cannot fetch a geography on objects other than" ,
                     " CrunchGeography or CrunchVaraibles.")
    })

    test_that("getGeoDataFrame errors", {
        expect_GET(fetchGeoFile(ds$location),
                   'https://s.crunch.io/some/wrong/gb_eer_doesnotexist.topojson')
        expect_error(getGeoDataFrame("foo", "bar"),
                     "The data object \\(", dQuote("bar"),
                     "\\) is not a Crunch dataset.")
        expect_error(getGeoDataFrame("foo", ds),
                     "The geo_var object \\(", dQuote("foo"),
                     "\\) is not a variable in the dataset provided.")
        expect_error(getGeoDataFrame("gender", ds),
                     "The geo_var \\(", dQuote("gender"), "\\) does not have any",
                     "geographic metadata associated with it. Please contact ",
                     "support@crunch.io for help associating geographic metadata.")
    })
})
