# Assignment 2 Technical analysis preliminary stage

Prepared for Oluwabunmi, BDA400. AI-assisted code and documentation drafted with ChatGPT on 25 November 2026. R execution, package installation and live data downloads are not verified in the preparation environment.

1. Install R from CRAN, then RStudio Desktop from Posit. Capture your installation screens.
2. Open this Assignment2 folder in RStudio and set it as the working directory.
3. Run `install.packages(c("quantmod", "TTR"))` once. Capture the successful installation and package version output.
4. Open portfolio.txt. The illustrative portfolio is AAPL, MSFT and GOOG, one per line.
5. Run `source("Oluwabunmi_BDA400_A02_Run.R")`.
6. Inspect the printed tables and outputs folder. Capture each stock's imported rows, the statistics table and the charts. Insert the genuine screenshots into the report where indicated.

The fixed query period is 1 September 2026 to 1 November 2026 (exclusive). Statistics use the Adjusted price column in USD. Downloads come from Yahoo Finance via quantmod; data may be revised. These tickers are examples for coursework, not investment recommendations.

Each `stocks[[symbol]]` element is a separate ordinary data frame with Date, Open, High, Low, Close, Volume and Adjusted fields. Summaries exclude nonfinite prices. Sample SD uses n-1. The five-observation SMA retains leading missing values and does not bridge a missing price. Mode uses exact values and returns all repeated ties; it reports no repeated value when every observation is unique. Charts compare price and SMA separately for each symbol; raw price levels are not comparable returns.

The Word report is a preparation draft until the required local screenshots and observed results are inserted. The cover page includes the real repository link. No test results, downloaded prices or completed installations have been invented.
