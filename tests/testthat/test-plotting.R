optObj <- function() {
  structure(
    list(
      optPars = list(acq = "ucb"),
      scoreSummary = data.table::data.table(
        Epoch = c(0, 0, 1, 2),
        Score = c(1, 2, 3, 2.5),
        gpUtility = c(NA, NA, 0.8, 0.6),
        acqOptimum = c(FALSE, FALSE, TRUE, TRUE)
      )
    ),
    class = "bayesOpt"
  )
}

test_that("plot() draws and returns the object invisibly", {
  obj <- optObj()

  expect_invisible(plot(obj))
  expect_identical(plot(obj), obj)
})

test_that("plot() arguments override the defaults", {
  captured <- NULL
  local_mocked_bindings(
    tinyplot = function(...) captured <<- list(...)
  )

  plot(optObj())
  expect_equal(captured$main, "Bayesian Optimization Results")
  expect_equal(captured$facet.args, list(nrow = 2, free = TRUE))

  plot(optObj(), main = "Custom", facet.args = list(nrow = 1))
  expect_equal(captured$main, "Custom")
  expect_equal(captured$facet.args, list(nrow = 1, free = TRUE))
})

test_that("plot() rejects unnamed arguments", {
  expect_error(plot(optObj(), 2), "must be named")
})

test_that("plotProgress = TRUE plots during the run", {
  skip_on_cran()
  set.seed(0)

  FUN <- function(x, y) list(Score = 1000 - (x - 5)^2 - (y + 10)^2)
  bounds <- list(x = c(0, 15), y = c(-20, 100))

  expect_no_error(
    bayesOpt(
      FUN,
      bounds,
      initPoints = 4,
      iters.n = 2,
      plotProgress = TRUE,
      verbose = 0
    )
  )
})
