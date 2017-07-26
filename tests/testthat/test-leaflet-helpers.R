context("leaflet helpers")


test_that("leaflet_hover", {
    df <- data.frame(names=c("foo", "bar"), perc=c(10, 20))
    # this test is sensitive to white-space.
    expect_equal(with(df, leaflet_hover(names, "perc", perc)),
                list(htmltools::HTML(
                        "<div style='font-size:12px;float:left'>
            <span style='font-size:18px;font-weight:bold'>foo</span>
            </br>
            <span style='font-size:14px'>perc 10%</span>
            </div>"),
                     htmltools::HTML(
                         "<div style='font-size:12px;float:left'>
            <span style='font-size:18px;font-weight:bold'>bar</span>
            </br>
            <span style='font-size:14px'>perc 20%</span>
            </div>")
                ))
})
