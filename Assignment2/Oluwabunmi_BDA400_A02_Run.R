# AI-assisted runner; execute from the Assignment2 directory.
# First run once in the R console:
# install.packages(c("quantmod", "TTR"))
needed <- c("quantmod", "TTR", "zoo")
missing <- needed[!vapply(needed, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Install missing packages: ", paste(missing, collapse = ", "))
source("Oluwabunmi_BDA400_A02_Functions.R")
source("Oluwabunmi_BDA400_A02_Display.R")
dir.create("outputs", showWarnings = FALSE)
result <- load_stock_data()
stocks <- result$stocks
statistics <- lapply(stocks, calculate_statistics, window = 5L)
summary_table <- do.call(rbind, lapply(names(statistics), function(symbol) {
  data.frame(Symbol = symbol, statistics[[symbol]]$summary, row.names = NULL)
}))
display_stock_data(stocks)
print(summary_table, row.names = FALSE)
for (symbol in names(stocks)) {
  utils::write.csv(stocks[[symbol]], file.path("outputs", paste0(symbol, "_data.csv")), row.names = FALSE)
  utils::write.csv(statistics[[symbol]]$series, file.path("outputs", paste0(symbol, "_SMA.csv")), row.names = FALSE)
}
utils::write.csv(summary_table, "outputs/statistics.csv", row.names = FALSE)
if (length(result$failures)) {
  utils::write.csv(data.frame(Symbol = names(result$failures), Error = unname(result$failures)),
                   "outputs/download_failures.csv", row.names = FALSE)
}
plot_paths <- plot_stock_data(stocks, statistics)
saveRDS(list(download = result, statistics = statistics), "outputs/analysis.rds")
capture.output(sessionInfo(), file = "outputs/session_info.txt")
writeLines(c(paste("Source:", result$source), paste("Downloaded:", result$downloaded_at),
             paste("From:", result$from), paste("To (exclusive):", result$to)), "outputs/data_source.txt")
cat("\nSaved data, statistics, rolling series, plots and session details in outputs/.\n")
if (length(result$failures)) stop("Partial run: fix failed symbols before submission.")
