# 📊 Tesla Stock Data Analysis (SQL-Based)

## 📌 Project Overview
This project explores Tesla (TSLA) historical stock data using SQL to uncover insights into price behavior, trading volume, volatility, and long-term trends.
The analysis focuses on transforming raw market data into meaningful financial metrics that support data-driven decision-making.

Unlike many stock analysis projects that rely on Python notebooks, this project demonstrates how SQL alone can be used for financial analytics and time-series analysis.

## 🎯 Objectives
The key goals of this analysis are to:
- Understand Tesla’s price movement over time
- Analyze trading volume behavior
- Identify volatility and daily price ranges
- Compute moving averages to detect trends
- Summarize overall stock performance using descriptive statistics

## 📌 Background

Financial time-series data is one of the most widely analyzed data types, commonly used to understand **stock performance, investor behavior, and overall market trends**. Among publicly traded companies, **Tesla** stands out as one of the most actively traded and volatile stocks, making it an excellent real-world dataset for analytical practice.

In this project, I explored **Tesla’s historical stock data** to uncover patterns related to **price movement, volatility, daily performance, and technical indicators**. The dataset contains daily trading records, including the date, open price, close price, high, low, and trading volume.

By applying **SQL-based time-series techniques** such as window functions, moving averages, return calculations, and performance grouping, this analysis demonstrates how SQL can be used for **data cleaning, trend identification, risk analysis, and technical signal detection**. Overall, the project serves both as a learning exercise and a practical demonstration of **SQL skills relevant to data analysis, finance, and data engineering roles**.


## 🛠 Tools & Technologies  
The following tools and technologies were used throughout the project:

- **PostgreSQL** – For data cleaning, staging, and executing all SQL time-series analysis queries.  
- **VS Code** – Used as the development environment for writing SQL scripts and managing the project files.  
- **Git & GitHub** – For version control and publishing the project as a public repository.  
- **CSV Dataset** – The Tesla historical stock data served as the source file for all analysis.  

These tools allowed me to build a structured SQL workflow, clean the dataset efficiently, and perform detailed time-series analysis.

---
## 📈 Analysis Breakdown 
This project answers several key time-series and performance questions about Tesla’s stock.  
Each question includes the purpose behind the analysis and the SQL script used to solve it. Here's how i approached each question:

### 1️⃣ Daily Trading Range

To calculate Tesla’s daily trading range, I queried each trading day’s high and low prices from the staging table. The query computes the difference between the high and low to determine the daily trading range, which is a key measure of intraday volatility. This helps identify unusually volatile days and provides context for understanding Tesla’s price behavior.

```sql
SELECT 
    date,
    high,
    low,
    high - low AS daily_trading_range
FROM ts_data_staging
ORDER BY date;
```

![Daily Trading Range](/Assets/01_daily_trading_range.png)

Here's the breakdown of Tesla’s daily trading range:

- Most daily trading ranges fall between 0.10 and 0.50, indicating that Tesla’s price generally moved within a predictable band during this period.

- Occasional volatility spikes are visible, such as on June 16, 2014, when the trading range reached 1.28—one of the highest in the dataset—signaling an unusually active or news-driven day.

- Low-volatility days (0.15–0.30 range) are the most common, suggesting the stock experienced more stable periods than highly volatile ones.

Overall, the daily trading range provides a foundational view of Tesla’s intraday volatility and sets the stage for deeper analyses like returns, moving averages, and trading signals.

### 2️⃣ Overall Summary Statistics

To understand Tesla’s overall price and trading behavior, I computed summary statistics for the opening price, closing price, and traded volume across the entire dataset. These metrics provide a broad view of price levels, volatility, and market activity over time.

```sql
SELECT
    MIN(open) AS overall_min_open,
    MAX(open) AS overall_max_open,
    ROUND(AVG(open), 2) AS overall_avg_open,
    MIN(close) AS overall_min_close,
    MAX(close) AS overall_max_close,
    ROUND(AVG(close), 2) AS overall_avg_close,
    MIN(volume) AS overall_min_volume,
    MAX(volume) AS overall_max_volume,
    ROUND(AVG(volume), 2) AS overall_avg_volume,
    SUM(volume) AS total_volume_traded
FROM ts_data_staging;
```

| Metric                  | Value           |
|:------------------------:|:---------------:|
| Overall Min Open         | 1.08            |
| Overall Max Open         | 475.90          |
| Overall Avg Open         | 96.81           |
| Overall Min Close        | 1.05            |
| Overall Max Close        | 479.86          |
| Overall Avg Close        | 96.78           |
| Overall Min Volume       | 1,777,500       |
| Overall Max Volume       | 914,082,000     |
| Overall Avg Volume       | 96,900,423.22   |
| Total Volume Traded      | 375,586,040,400 |

Here's the breakdown of Tesla’s overall trading statistics:

- **Opening and Closing Prices:**
The stock opened as low as $1.08 and closed as low as $1.05 in its early trading history, while the highest open and close were $475.90 and $479.86, respectively. The average opening and closing prices were very similar, around $96.81 and $96.78, indicating a balanced overall trading trend.

- **Volume:**
Daily trading volume ranged from 1,777,500 to 914,082,000 shares, with an average of 96,900,423 shares traded per day. This highlights periods of extreme activity and quieter trading days.

- **Total Market Activity:**
Across the dataset, a total of 375,586,040,400 shares were traded, showing the massive scale of Tesla’s market activity over time.

### 3️⃣ Top 5 Best and Worst Trading Days by % Return

To identify Tesla’s most extreme daily moves, I calculated the daily percentage return using the previous day’s closing price. This highlights both unusually profitable days and sharply declining days, providing insight into periods of extreme market activity or news-driven volatility.

```sql
-- Daily Returns CTE
WITH daily_returns AS (
    SELECT 
        date,
        close,
        LAG(close) OVER (ORDER BY date) AS prev_close
    FROM ts_data_staging
)
-- Top 5 Best Days
SELECT 
    date,
    ROUND(((close - prev_close) / prev_close) * 100, 2) AS daily_return_pct
FROM daily_returns
WHERE prev_close IS NOT NULL
ORDER BY daily_return_pct DESC
LIMIT 5;

-- Top 5 Worst Days
WITH daily_returns AS (
    SELECT 
        date,
        close,
        LAG(close) OVER (ORDER BY date) AS prev_close
    FROM ts_data_staging
)
SELECT 
    date,
    ROUND(((close - prev_close) / prev_close) * 100, 2) AS daily_return_pct
FROM daily_returns
WHERE prev_close IS NOT NULL
ORDER BY daily_return_pct ASC
LIMIT 5;
```
Here's the breakdown of Tesla’s top 5 best and worst trading days by percentage return:

**Top 5 Best Trading Days:**
These days reflect the highest positive returns, often driven by major news, earnings beats, or market optimism. 

- May 9, 2013: 24.46%
- April 9, 2025: 22.69%
- October 24, 2024: 21.92%
- February 3, 2020: 19.90%

- March 9, 2021: 19.64%

These high positive returns indicate days of extreme bullish activity, often triggered by significant news, earnings beats, or market optimism. Such insights help highlight periods of exceptional growth and investor enthusiasm in Tesla’s trading history.

**Top 5 Worst Trading Days:**
Here's the breakdown of Tesla’s worst daily returns:

- September 8, 2020: -21.06%

- January 13, 2012: -19.15%

- March 16, 2020: -18.58%
- February 5, 2020: -17.18%

- July 6, 2010: -16.41%

These large negative returns indicate extreme market reactions, possibly due to earnings misses, global events, or company-specific shocks.

![Top 5 Best-Worst Trading Days](/Assets/02_top5_good_worst_days.png)


Overall, analyzing the best and worst trading days by percentage return helps identify periods of high risk and volatility, which is essential for traders, risk managers, and long-term investors evaluating Tesla’s stock behavior.

### 4️⃣  Market Trend Analysis

To analyze Tesla’s market trends, I calculated the 50-day and 200-day simple moving averages (SMA). Closing above the 50-day SMA indicates short-term bullish momentum, while closing below the 200-day SMA may signal a long-term bearish trend.

``` sql
WITH moving_averages AS (
    SELECT
        date,
        close,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS sma_50,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS sma_200
    FROM ts_data_staging
)
-- Count days closing above 50-day SMA
SELECT
    COUNT(*) AS days_above_50_sma,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM moving_averages WHERE sma_50 IS NOT NULL), 2) AS pct_time_above_50_sma
FROM moving_averages
WHERE close > sma_50 AND sma_50 IS NOT NULL;

WITH moving_averages AS (
    SELECT
        date,
        close,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS sma_50,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS sma_200
    FROM ts_data_staging
)
-- Last date the stock closed below 200-day SMA
SELECT 
    date, 
    close, 
    ROUND(sma_200, 2) AS sma_200
FROM moving_averages
WHERE close < sma_200
ORDER BY date DESC
LIMIT 1;
```

| days_above_50_sma | pct_time_above_50_sma | date | close | sma_200 |
| :----------: | :----------: | :----------: | :----------: | :----------: | 
| 2230 | 57.53 | 2025-09-02 | 329.36 | 329.94 |

**Breakdown / Insights:**

- **Days Above 50-day SMA: 2,230**

- **Percentage of time above 50-day SMA: 57.53%**

Tesla closed above its 50-day SMA 57.53% of the time, showing consistent short-term bullish momentum.

- **Last Close Below 200-day SMA:**
    - *Date:* September 2, 2025

    - *Close:* $329.36

    - *200-day SMA:* $329.94

This indicates that Tesla has mostly stayed above its 200-day SMA, suggesting a strong long-term bullish trend, with only occasional dips below this long-term average.

### 5️⃣ Strategy Signal Generation (Golden / Death Cross)

To identify potential trend signals, I calculated the 50-day and 200-day simple moving averages (SMA). A Golden Cross occurs when the 50-day SMA crosses above the 200-day SMA, signaling a potential bullish trend. Conversely, a Death Cross occurs when the 50-day SMA crosses below the 200-day SMA, signaling a potential bearish trend.

``` sql
WITH moving_averages AS (
    SELECT
        date,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS sma_50,
        AVG(close) OVER (ORDER BY date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW) AS sma_200
    FROM ts_data_staging
),
cross_check AS (
    SELECT
        date,
        sma_50,
        sma_200,
        LAG(CASE WHEN sma_50 > sma_200 THEN 1 ELSE 0 END) OVER (ORDER BY date) AS was_bullish_yesterday,
        CASE WHEN sma_50 > sma_200 THEN 1 ELSE 0 END AS is_bullish_today
    FROM moving_averages
    WHERE sma_200 IS NOT NULL
)
SELECT
    date,
    CASE
        WHEN is_bullish_today = 1 AND was_bullish_yesterday = 0 THEN 'Golden Cross'
        WHEN is_bullish_today = 0 AND was_bullish_yesterday = 1 THEN 'Death Cross'
        ELSE NULL
    END AS cross_signal
FROM cross_check
WHERE (is_bullish_today = 1 AND was_bullish_yesterday = 0)
   OR (is_bullish_today = 0 AND was_bullish_yesterday = 1)
ORDER BY date;
```

![Open performance](/Assets/06_open_performance.png)


**Breakdown / Insights:**

Tesla experienced multiple Golden Crosses and Death Crosses over its trading history, highlighting periods of trend reversals and momentum shifts.

**Golden Cross Examples:**

- September 17, 2010

- March 31, 2011

- November 3, 2011

- May 2, 2016

- September 16, 2025

These dates mark potential bullish trends where short-term momentum overtakes long-term averages, often signaling buying opportunities.

**Death Cross Examples:**

- March 29, 2011

- August 26, 2011

- July 6, 2012

- February 1, 2024

- August 5, 2025

These dates indicate potential bearish trends where short-term momentum falls below long-term averages, often signaling caution or potential selling periods.

### 6️⃣ Performance vs. Market Open

To analyze how Tesla performs relative to the previous day’s close, I calculated daily returns and compared average returns on days when the stock opened higher versus lower than the prior close. This helps determine whether momentum at the open correlates with positive or negative performance for the day.

``` sql
WITH daily_returns AS (
    SELECT
        date,
        open,
        close,
        LAG(close) OVER (ORDER BY date) AS prev_close,
        ((close - LAG(close) OVER (ORDER BY date)) / LAG(close) OVER (ORDER BY date)) * 100 AS daily_return_pct
    FROM ts_data_staging
)
SELECT
    ROUND(AVG(CASE WHEN open > prev_close THEN daily_return_pct END), 2) AS avg_return_on_open_up_days,
    ROUND(AVG(CASE WHEN open < prev_close THEN daily_return_pct END), 2) AS avg_return_on_open_down_days
FROM daily_returns
WHERE prev_close IS NOT NULL;
```

| avg_return_on_open_up_days |avg_return_on_open_down_days |
| :-------------------: | :-------------------: |
| 1.40 | -1.29 |


**Breakdown / Insights:**

- **Average Return on Open-Up Days:** 1.40%
When Tesla opened higher than the previous day’s close, it tended to gain on average, suggesting positive momentum carries through the trading day.

- **Average Return on Open-Down Days:** -1.29%
When Tesla opened lower than the previous day’s close, it tended to decline on average, indicating that negative opening gaps often persist throughout the day.

Overall, this analysis shows that Tesla’s opening price relative to the prior close is a useful indicator of intraday performance. Positive gaps generally lead to gains, while negative gaps tend to continue downward, which can inform short-term trading strategies.

## ✅ Conclusion
This project demonstrates how **SQL can be effectively used for financial and time-series analysis** on real-world stock market data. By analyzing Tesla’s historical stock prices and trading volumes, key patterns around **volatility, price movement, and market activity** were uncovered.

Through summary statistics, daily trading range calculations, volume analysis, and moving averages, the project shows how raw stock data can be transformed into **actionable insights** that support trend identification and performance evaluation. The analysis highlights Tesla’s periods of rapid growth, heightened volatility, and strong market participation.

Overall, this project reinforces the importance of **structured querying, data exploration, and analytical reasoning** in financial analytics. It also demonstrates how SQL alone can be a powerful tool for extracting insights from large datasets, forming a solid foundation for more advanced analysis using visualization tools or programming languages in future work.


## 📘 What I Learned
Working on this project significantly improved my **SQL skills** and expanded my understanding of what SQL can be used for beyond basic data retrieval. I learned how to apply SQL to **financial and time-series analysis**, including calculating summary statistics, daily price movements, trading volume patterns, and moving averages.

This project also showed me the **broader possibilities of SQL** in real-world analytics. I gained confidence in writing more complex queries, structuring analysis logically, and using SQL to answer meaningful business and market-related questions. Overall, it strengthened my problem-solving approach and reinforced SQL as a powerful tool for data exploration, analysis, and decision support.

