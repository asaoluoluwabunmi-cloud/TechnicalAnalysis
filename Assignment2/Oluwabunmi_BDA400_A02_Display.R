display_stock_data <- function(stocks, rows = 6L) {
  if (length(rows) != 1L || !is.finite(rows) || rows < 1 || rows != floor(rows))
    stop("rows must be a positive integer.")
  for (symbol in names(stocks)) {
    cat("\n", symbol, ": first observations\n", sep = "")
    print(utils::head(stocks[[symbol]], rows), row.names = FALSE)
    cat("Last observations\n"); print(utils::tail(stocks[[symbol]], rows), row.names = FALSE)
  }
  invisible(stocks)
}

plot_stock_data <- function(stocks, statistics, output_dir = "outputs") {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  paths <- character()
  for (symbol in names(stocks)) {
    path <- file.path(output_dir, paste0(gsub("[^A-Za-z0-9_-]", "_", symbol), "_price_SMA.png"))
    grDevices::png(path, width = 1400, height = 900, res = 140)
    tryCatch({
      series <- statistics[[symbol]]$series
      graphics::plot(series$Date, series$Price, type = "l", col = "#174A6E",
                     xlab = "Trading date", ylab = "Adjusted price (USD)",
                     main = paste(symbol, "adjusted price and", statistics[[symbol]]$summary$SMA_Window, "observation SMA"))
      graphics::lines(series$Date, series$SMA, col = "#A64B00", lwd = 2)
      graphics::legend("topleft", c("Adjusted price", "Simple moving average"),
                       col = c("#174A6E", "#A64B00"), lty = 1, bty = "n")
      graphics::grid()
    }, finally = grDevices::dev.off())
    paths[symbol] <- path
  }
  invisible(paths)
}
