# Assignment 2 Technical analysis preliminary stage

Prepared for Oluwabunmi, BDA400. The workflow was executed successfully on a GitHub Actions Ubuntu runner on 25 November 2026 using R 4.5.2, quantmod 0.4.28 and TTR 0.24.4. Actual data, summary statistics, charts and logs are included in outputs/. This cloud execution does not establish local RStudio installation.

1. Install R from CRAN, then RStudio Desktop from Posit. Capture your installation screens.
2. Open this Assignment2 folder in RStudio and set it as the working directory.
3. Run `install.packages(c("quantmod", "TTR"))` once. Capture the successful installation and package version output.
4. Open portfolio.txt. The illustrative portfolio is AAPL, MSFT and GOOG, one per line.
5. Run `source("Oluwabunmi_BDA400_A02_Run.R")`.
6. Inspect the printed tables and outputs folder. Capture each stock's imported rows, the statistics table and the charts. Insert the genuine screenshots into the report where indicated.

The fixed query period is 1 September 2026 to 1 November 2026 (exclusive). Statistics use the Adjusted price column in USD. Downloads come from Yahoo Finance via quantmod; data may be revised. These tickers are examples for coursework, not investment recommendations.

Each `stocks[[symbol]]` element is a separate ordinary data frame with Date, Open, High, Low, Close, Volume and Adjusted fields. Summaries exclude nonfinite prices. Sample SD uses n-1. The five-observation SMA retains leading missing values and does not bridge a missing price. Mode uses exact values and returns all repeated ties; it reports no repeated value when every observation is unique. Charts compare price and SMA separately for each symbol; raw price levels are not comparable returns.

Execution evidence: https://github.com/asaoluoluwabunmi-cloud/TechnicalAnalysis/actions/runs/45535244196
Tested commit: f31adbee46206f005c3e7b9feaccbb18cd4fecc7. Subsequent source edits remove comments only.

Execution evidence: https://github.com/asaoluoluwabunmi-cloud/TechnicalAnalysis/actions/runs/45535244196
Tested commit: f31adbee46206f005c3e7b9feaccbb18cd4fecc7. Subsequent source edits remove comments only.

Execution evidence: https://github.com/asaoluoluwabunmi-cloud/TechnicalAnalysis/actions/runs/45535244196
Tested commit: f31adbee46206f005c3e7b9feaccbb18cd4fecc7. Subsequent source edits remove comments only.
