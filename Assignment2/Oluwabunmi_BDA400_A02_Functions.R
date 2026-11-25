load_stock_data <- function(portfolio_file = "portfolio.txt",
                            from = as.Date("2026-09-01"),
                            to = as.Date("2026-11-01")) {
  if (!requireNamespace("quantmod", quietly = TRUE)) stop("Install quantmod first.")
  if (!file.exists(portfolio_file)) stop("Portfolio file does not exist: ", portfolio_file)
  from <- as.Date(from); to <- as.Date(to)
  if (length(from) != 1L || length(to) != 1L || is.na(from) || is.na(to) || from >= to)
    stop("Use valid from and to dates, with from earlier than to.")
  symbols <- unique(toupper(trimws(readLines(portfolio_file, warn = FALSE))))
  symbols <- symbols[nzchar(symbols) & !startsWith(symbols, "#")]
  if (!length(symbols)) stop("Portfolio contains no symbols.")
  stocks <- list(); failures <- character()
  for (symbol in symbols) {
    tryCatch({
      prices <- quantmod::getSymbols(symbol, src = "yahoo", from = from,
                                    to = to, auto.assign = FALSE)
      if (NROW(prices) == 0L) stop("No rows returned.")
      frame <- data.frame(
        Date = as.Date(zoo::index(prices)),
        Open = as.numeric(quantmod::Op(prices)),
        High = as.numeric(quantmod::Hi(prices)),
        Low = as.numeric(quantmod::Lo(prices)),
        Close = as.numeric(quantmod::Cl(prices)),
        Volume = as.numeric(quantmod::Vo(prices)),
        Adjusted = as.numeric(quantmod::Ad(prices))
      )
      frame <- frame[order(frame$Date), , drop = FALSE]
      if (anyDuplicated(frame$Date)) stop("Duplicate dates returned.")
      stocks[[symbol]] <- frame
    }, error = function(e) {
      failures[symbol] <<- conditionMessage(e)
    })
  }
  if (!length(stocks)) stop("All downloads failed: ", paste(names(failures), failures, collapse = "; "))
  if (length(failures)) warning("Some downloads failed; inspect result$failures.")
  list(stocks = stocks, failures = failures, requested_symbols = symbols,
       from = from, to = to, downloaded_at = Sys.time(), source = "Yahoo Finance via quantmod")
}

# Statistical mode, not base R mode(), which describes storage type.
# Returns every exact tie; no repeated value means there is no unique frequency peak.
statistical_modes <- function(x) {
  x <- x[is.finite(x)]
  if (!length(x)) return(numeric())
  values <- sort(unique(x)); counts <- tabulate(match(x, values))
  if (max(counts) == 1L) return(numeric())
  values[counts == max(counts)]
}

calculate_statistics <- function(stock, window = 5L, price_column = "Adjusted") {
  if (!requireNamespace("TTR", quietly = TRUE)) stop("Install TTR first.")
  if (!is.data.frame(stock) || !all(c("Date", price_column) %in% names(stock)))
    stop("Expected a data frame with Date and the selected price column.")
  if (length(window) != 1L || !is.numeric(window) || !is.finite(window) ||
      window < 1 || window != floor(window)) stop("window must be a positive integer.")
  if (!inherits(stock$Date, "Date") || anyNA(stock$Date) || anyDuplicated(stock$Date))
    stop("Dates must be unique, nonmissing Date values.")
  stock <- stock[order(stock$Date), , drop = FALSE]
  x <- stock[[price_column]]
  if (!is.numeric(x)) stop("Price column must be numeric.")
  valid <- is.finite(x); clean <- x[valid]
  if (!length(clean)) stop("No finite price values.")
  # Do not bridge missing trading observations in a rolling window.
  sma <- rep(NA_real_, length(x))
  runs <- rle(valid); ends <- cumsum(runs$lengths); starts <- ends - runs$lengths + 1L
  for (i in seq_along(runs$lengths)) {
    if (runs$values[i] && runs$lengths[i] >= window) {
      idx <- seq.int(starts[i], ends[i]); sma[idx] <- as.numeric(TTR::SMA(x[idx], n = window))
    }
  }
  modes <- statistical_modes(clean)
  summary <- data.frame(
    Price_Field = price_column, N = length(clean), Missing = sum(!valid),
    Mean = mean(clean), Median = median(clean),
    Mode = if (length(modes)) paste(format(modes, digits = 12, trim = TRUE), collapse = "; ") else "No repeated value",
    SD = if (length(clean) > 1L) stats::sd(clean) else NA_real_,
    SMA_Window = window, Latest_SMA = tail(sma, 1L), stringsAsFactors = FALSE
  )
  list(summary = summary, series = data.frame(Date = stock$Date, Price = x, SMA = sma), modes = modes)
}
