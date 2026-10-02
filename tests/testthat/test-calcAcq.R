design <- data.frame(x = c(0, 0.25, 0.5, 0.75, 1))
scoreGP <- DiceKriging::km(
  design = design,
  response = sin(3 * design$x),
  control = list(trace = 0)
)
timeGP <- DiceKriging::km(
  design = design,
  response = c(0.2, 0.4, 0.6, 0.8, 1),
  control = list(trace = 0)
)

par <- c(x = 0.6)
pred <- predict(scoreGP, data.frame(x = 0.6), type = "SK")
y_max <- max(sin(3 * design$x))
kappa <- 2.576
eps <- 0.01
z <- (pred$mean - y_max - eps) / pred$sd
ei <- (pred$mean - y_max - eps) * pnorm(z) + pred$sd * dnorm(z)

acq <- function(type) {
  calcAcq(par, scoreGP, timeGP, type, y_max, kappa, eps)
}

test_that("ucb is the mean plus kappa standard deviations", {
  expect_equal(acq("ucb"), pred$mean + kappa * pred$sd)
})

test_that("ei is the expected improvement over y_max", {
  expect_equal(acq("ei"), ei)
})

test_that("eips divides ei by the predicted time", {
  timePred <- predict(timeGP, data.frame(x = 0.6), type = "SK")
  expect_equal(acq("eips"), ei / timePred$mean)
})

test_that("poi is the probability of improvement over y_max", {
  expect_equal(acq("poi"), pnorm(z))
})
