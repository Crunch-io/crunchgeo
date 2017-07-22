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
        expect_error(fetchGeoFile(geo_data),
                     'Cannot open data source')
        expect_GET(fetchGeoFile(test_crGeo),
                   'https://s.crunch.io/some/wrong/path.geojson')
        test_crGeo$geodatum$location <- "https://notajsonatall.nope"
        expect_error(fetchGeoFile(test_crGeo), "Unknown filetype ", dQuote("nope"), " in geodata url: ", "https://notajsonatall.nope")
    })
})
