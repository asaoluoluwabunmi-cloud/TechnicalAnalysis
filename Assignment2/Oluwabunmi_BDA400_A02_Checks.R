source("Oluwabunmi_BDA400_A02_Functions.R")
example <- data.frame(Date = as.Date("2026-01-01") + 0:4, Adjusted = c(1, 2, 2, 3, 7))
a <- calculate_statistics(example, window = 3L)
stopifnot(isTRUE(all.equal(a$summary$Mean, 3)),
          isTRUE(all.equal(a$summary$Median, 2)),
          isTRUE(all.equal(a$modes, 2)),
          isTRUE(all.equal(a$summary$SD, sqrt(5.5))),
          all(is.na(a$series$SMA[1:2])),
          isTRUE(all.equal(a$series$SMA[3:5], c(5/3, 7/3, 4))))
stopifnot(identical(statistical_modes(c(1, 1, 2, 2)), c(1, 2)),
          length(statistical_modes(c(1, 2, 3))) == 0L)
example$Adjusted[3] <- NA_real_
b <- calculate_statistics(example, window = 3L)
stopifnot(all(is.na(b$series$SMA)), b$summary$Missing == 1L)
stopifnot(inherits(try(calculate_statistics(example, window = 0L), silent = TRUE), "try-error"))
cat("All deterministic checks passed.\n")
