#' Plot a \code{bayesOpt} object
#'
#' Draws 2 stacked plots - the top shows the results from FUN at each iteration.
#' The bottom shows the utility from each point before the search took place.
#'
#' @param x An object of class bayesOpt
#' @param ... Named arguments passed to \code{tinyplot::tinyplot()},
#'   overriding the defaults. List arguments such as \code{facet.args} and
#'   \code{legend} are merged with the defaults rather than replacing them.
#' @importFrom tinyplot tinyplot
#' @importFrom graphics plot
#' @importFrom utils modifyList
#' @return \code{x}, invisibly. The plot is drawn on the current device.
#' @examples
#' scoringFunction <- function(x) {
#'   a <- exp(-(2-x)^2)*1.5
#'   b <- exp(-(4-x)^2)*2
#'   c <- exp(-(6-x)^2)*1
#'   return(list(Score = a+b+c))
#' }
#'
#' bounds <- list(x = c(0,8))
#'
#' Results <- bayesOpt(
#'     FUN = scoringFunction
#'   , bounds = bounds
#'   , initPoints = 3
#'   , iters.n = 2
#'   , gsPoints = 10
#' )
#' # This plot will also show in real time with parameter plotProgress = TRUE in bayesOpt()
#' plot(Results)
#' @export
plot.bayesOpt <- function(x, ...) {
  dots <- list(...)
  if (length(dots) > 0 && (is.null(names(dots)) || any(names(dots) == ""))) {
    stop("All arguments in ... must be named.")
  }

  scoreSummary <- x$scoreSummary[!is.na(get("Score")), ]
  utility <- scoreSummary[!is.na(get("gpUtility")), ]

  # Stack the score and utility in long format so each gets its own facet.
  long <- data.frame(
    Epoch = c(scoreSummary$Epoch, utility$Epoch),
    value = c(scoreSummary$Score, utility$gpUtility),
    metric = factor(
      rep(c("Score", "Utility"), c(nrow(scoreSummary), nrow(utility)))
    ),
    optimum = factor(
      c(scoreSummary$acqOptimum, utility$acqOptimum),
      levels = c(TRUE, FALSE)
    )
  )

  defaults <- list(
    facet = ~metric,
    facet.args = list(nrow = 2, free = TRUE),
    xlim = range(scoreSummary$Epoch),
    ylab = "",
    pch = 19,
    main = "Bayesian Optimization Results",
    legend = list("bottom!", title = "Local optimum")
  )

  do.call(
    tinyplot,
    c(list(value ~ Epoch | optimum, data = long), modifyList(defaults, dots))
  )

  invisible(x)
}
