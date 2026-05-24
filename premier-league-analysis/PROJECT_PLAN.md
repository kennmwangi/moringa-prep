⚽ Premier League Performance Analysis (2018-2025)
📌 Project Overview
An end-to-end data analytics project exploring 7 seasons of English Premier League match data. The goal of this analysis was to quantify established football narratives—such as the true value of home-field advantage—and extract actionable insights regarding team consistency, scoring trends, and win probabilities using advanced SQL modeling and Python data visualization.

🗄️ Dataset & Data Engineering
Source: football-data.co.uk

Period: 2018-19 to 2024-25 seasons

Volume: Exactly 2,660 matches (7 seasons × 380 matches per season)

Data Cleaning Highlights:

Engineered surgical DELETE statements using hidden SQLite rowids to eliminate duplicate bulk-load imports.

Standardized inconsistent date string formats (DD/MM/YYYY to YYYY-MM-DD) to enable chronological window functions and accurate seasonal grouping.

💡 Key Insights & Findings
1. The Home Advantage is Real (and Quantifiable)
Finding: Across 7 seasons, home teams won 44.14% of their matches, while away teams won only 33.46% (Draws accounted for 22.41%).

Insight: Playing at home provides a baseline ~11% increase in win probability. Visualized via grouped bar charts, teams like Newcastle and Aston Villa exhibited massive "Home Advantage Deltas," relying almost entirely on their home fortress to secure league points.

2. League Table Reconstruction & Margins
Finding: Successfully reconstructed official season standings entirely from raw match results (Home Goals vs. Away Goals).

Insight: A regression scatter plot comparing Total Goals to Final Points proves that outscoring the league does not guarantee a title. Teams maximizing points through defensive efficiency often outperform teams that score heavily in blowouts but drop crucial points elsewhere.

3. Win Streaks & Team Consistency (The Volatility Matrix)
Consistent Elite: Manchester City and Liverpool consistently ranked at the top of the consistency index, rarely dropping below the top 4.

Volatility Trap: A multi-dimensional bubble matrix highlighted a massive gap between the "Big 6" and the rest of the league. Notably, Manchester United and Tottenham were exposed as "Highly Volatile," swinging wildly across the table year over year despite premium budgets.

4. Big 6 Head-to-Head Dominance
Finding: Mapped out exact win/loss records between the top clubs over 7 years using a Seaborn heatmap.

Insight: Visually exposed severe one-sided rivalries, such as Arsenal's statistical dominance over Manchester United, and Chelsea's multi-year struggles against the rest of the top tier.

🛠️ Technical Skills Showcased
SQL & Data Architecture
Complex Aggregations: SUM, AVG, and COUNT combined with mathematical formulas to calculate precise win percentages.

Data Transformation: Heavy use of CASE WHEN statements to assign match points (3 for a win, 1 for a draw) based on H, A, or D string values.

Common Table Expressions (CTEs): Built nested, multi-step CTEs to separate Home and Away performance before joining them into master summary tables.

Window Functions: Utilized ROW_NUMBER() and RANK() partitioned by team and ordered chronologically to identify longest consecutive win streaks.

String Manipulation: Used SUBSTR() to extract specific years from raw date strings for cohort analysis.

Python Visualization & Analysis
Pandas Dataframes: Handled data restructuring, melting, and pivoting to prepare SQL exports for visual rendering.

Seaborn & Matplotlib: Engineered professional-grade visualizations including:

Regression scatter plots (Goals vs. Points)

Head-to-Head heatmaps (Big 6 Rivalries)

Multi-dimensional bubble matrices (Team Consistency)

Annotated horizontal bar charts (Longest Win Streaks & Goal Margin Upsets)

💻 Tools Used
Database: SQLite

IDE / Environment: DBeaver, VS Code (Jupyter Notebooks)

Version Control: Git / GitHub

Language & Libraries: Python 3 (Pandas, Matplotlib, Seaborn)

📂 Project Structure
Plaintext
├── /data/                       # Contains raw CSVs and the exported cleaned datasets from DBeaver
├── /sql/                        # Contains the 7 analytical SQL scripts addressing the core business questions
├── pl_visualizations.ipynb      # The core Jupyter Notebook containing all Pandas logic and charting
├── FINDINGS.md                  # Detailed breakdown of specific match anomalies and upsets
└── README.md                    # Project overview and insights
