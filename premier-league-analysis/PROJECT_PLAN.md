# Premier League Performance Analysis (2018-2025)

## Project Overview
An end-to-end data analytics project exploring 7 seasons of English Premier League match data. The goal of this analysis was to quantify established football narratives—such as the true value of home-field advantage—and extract actionable insights regarding team consistency, scoring trends, and win probabilities using advanced SQL modeling.

## Dataset & Data Engineering
- **Source:** football-data.co.uk
- **Period:** 2018-19 to 2024-25 seasons
- **Volume:** Exactly 2,660 matches (7 seasons × 380 matches per season)
- **Data Cleaning Highlights:** - Engineered surgical `DELETE` statements using hidden SQLite `rowid`s to eliminate duplicate bulk-load imports.
  - Standardized inconsistent date string formats (`DD/MM/YYYY` to `YYYY-MM-DD`) to enable chronological window functions and accurate seasonal grouping.

## Key Insights & Findings

1. **The Home Advantage is Real (and Quantifiable)**
   - **Finding:** Across 7 seasons, home teams won **44.14%** of their matches, while away teams won only **33.46%** (Draws accounted for 22.41%).
   - **Insight:** Playing at home provides a baseline ~11% increase in win probability. Teams like Huddersfield exhibited massive "Home Advantage Deltas," relying almost entirely on their home fortress to secure league points.

2. **League Table Reconstruction & Margins**
   - Successfully reconstructed official season standings entirely from raw match results (Home Goals vs. Away Goals).
   - **Insight:** Top-tier championships are decided by razor-thin margins. Scoring the most goals does not guarantee a title; defensive consistency and head-to-head point accumulation often serve as the ultimate tie-breakers.

3. **Win Streaks & Team Consistency**
   - **Consistent Elite:** Manchester City and Liverpool consistently ranked at the top of the consistency index, rarely dropping below the top 4.
   - **Volatility:** The data highlighted a massive gap between the "Big 6" and the rest of the league, with most mid-table teams showcasing high volatility (bouncing between European contention and relegation battles).

## Technical SQL Skills Showcased
- **Complex Aggregations:** `SUM`, `AVG`, and `COUNT` combined with mathematical formulas to calculate precise win percentages.
- **Data Transformation:** Heavy use of `CASE WHEN` statements to assign match points (3 for a win, 1 for a draw) based on 'H', 'A', or 'D' string values.
- **Common Table Expressions (CTEs):** Built nested, multi-step CTEs to separate Home and Away performance before joining them into master summary tables.
- **Window Functions:** Utilized `ROW_NUMBER()` and `RANK()` partitioned by team and ordered chronologically to identify longest consecutive win streaks.
- **String Manipulation:** Used `SUBSTR()` to extract specific years from raw date strings for cohort analysis.

## Tools Used
- **Database:** SQLite 
- **IDE / Environment:** DBeaver, VS Code
- **Version Control:** Git / GitHub
- **Visualization:** Python (Pandas, Plotly/Matplotlib) — *In Progress*

## Project Structure
- `/data/`: Contains the raw CSVs and the final exported `clean_matches_master.csv`.
- `/sql/`: Contains the 7 analytical SQL scripts addressing the core business questions.
- `FINDINGS.md`: Detailed breakdown of specific match anomalies and upsets.

## Next Steps
- Connect the cleaned database to a Python environment to programmatically generate data visualizations (bar charts, line graphs of seasonal trends) to build an interactive FPL/Sports Analytics dashboard.