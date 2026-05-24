# ⚽ Premier League Analytics: 7-Year Performance & Volatility Study

> **Objective:** To quantify established football narratives (e.g., home-field advantage, scoring efficiency) and extract strategic team insights using advanced SQL modeling and Python data visualization.

---

## 🗄️ 1. The Dataset

* **Source:** [football-data.co.uk](https://www.football-data.co.uk/)
* **Scope:** 2018/19 to 2024/25 Seasons
* **Volume:** 2,660 individual matches

---

## 🛠️ 2. Tech Stack & Architecture

| Category | Tools & Libraries | Key Techniques Applied |
| --- | --- | --- |
| **Database** | SQLite, DBeaver | CTEs, Window Functions, Date Standardization |
| **Data Cleaning** | SQL | Duplicate eradication via hidden `rowid`, `CASE WHEN` logic |
| **Analysis** | Python 3, Pandas | Data restructuring, pivoting, and melting |
| **Visualization** | Seaborn, Matplotlib | Regression plots, heatmaps, multi-dimensional matrices |

---

## 💡 3. Key Analytical Insights

### 🏟️ The Home Advantage Delta

> **Home teams won 44.14% of matches compared to away teams at 33.46%.** * **The Takeaway:** Playing at home provides a baseline ~11% win probability boost. Grouped bar chart analysis revealed teams like Newcastle rely heavily on their home stadium to secure points, while championship contenders maintain flat consistency regardless of venue.

### 🎯 Efficiency Over Volume (Scorers vs. Champions)

> **Outscoring the league does not guarantee a title.**

* **The Takeaway:** A regression scatter plot (Total Goals vs. Final Points) proved that defensive efficiency often outweighs sheer scoring volume. Teams maximizing tight 1-0 wins consistently finished above teams that scored heavily in blowouts but dropped points elsewhere.

### 🎢 The Volatility Matrix

> **Manchester City & Liverpool are the stable elite; Tottenham & Man United are "Highly Volatile."**

* **The Takeaway:** A multi-dimensional bubble matrix exposed a massive gap between the "Big 6" and the rest of the league. Despite premium budgets, certain top-tier teams swing wildly across the final standings year over year.

### 🥊 Big 6 Head-to-Head Dominance

> **Rivalries are rarely balanced over a 7-year timeline.**

* **The Takeaway:** A Seaborn heatmap detailed the exact win/loss records between top clubs, exposing severe one-sided matchups—such as Arsenal's statistical dominance over Manchester United.

---

## 📂 4. Project Structure

```text
├── /data/                       # Raw CSVs and cleaned SQL exports
├── /sql/                        # 7 analytical SQL scripts (Aggregations, Window Functions)
├── pl_visualizations.ipynb      # Core Jupyter Notebook (Pandas logic & Seaborn charting)
├── FINDINGS.md                  # Detailed breakdown of match anomalies 
└── README.md                    # Project overview

```

---

*In the above project I explored the intersection of data science, predictive analytics, and sports strategy.*
