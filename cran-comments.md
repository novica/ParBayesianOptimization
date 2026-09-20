## Background

This package was archived on CRAN on 2026-01-12 ("issues were not corrected
despite reminders"). The fatal check failure was an error re-building the
`tuningHyperparameters` vignette: the example scoring function returned a
non-scalar `nrounds` value, which crashed `bayesOpt()`'s initialization.
That bug is fixed in this release.

Maintenance of this package has been picked up by a new maintainer
(novica); the original maintainer is credited as an author.

## Test environments

* GitHub Actions: ubuntu-latest (devel, release, oldrel-1), macos-latest
  (release), windows-latest (release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Downstream dependencies

There are no downstream dependencies.

## Resubmission notes

This is a resubmission of a previously archived package. In addition to
fixing the vignette-rebuild error that caused archival, vignettes were
migrated from knitr/rmarkdown to Quarto to remove the package's dependency
on a system pandoc installation during `R CMD check`.
