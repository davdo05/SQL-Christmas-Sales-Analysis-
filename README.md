# How it Works

This project is a full **SQL-based retail sales analysis** on a multi-year Christmas dataset. I used advanced SQL techniques — including **window functions, CTEs, and aggregations** — to uncover sales growth trends, customer segmentation insights, and product-level performance metrics. The analysis provided actionable insights into profitability, customer behavior, and regional sales dynamics.

---

## Data preparation

I worked with a structured sales dataset containing **transaction-level details**:  
- Date & time of purchase  
- Customer demographics (age, gender)  
- Product and category  
- Payment method & channel (online vs. in-store)  
- Location (region, country)  
- Revenue, cost, and profit figures  

This rich schema enabled both **time-series trend analysis** and **customer/product segmentation**.

---

## SQL analysis workflow

**1. Profitability trends**  
- Used `SUM()`, `AVG()`, and grouping by year/season to calculate revenue, cost, and profit per holiday period.  
- Excluded incomplete years (e.g., 2017–2018) to maintain accuracy.  
- Rounded values into millions for business readability.  

**2. Customer segmentation**  
- Segmented customers by **age group** and **gender**, analyzing revenue contribution and purchase volume.  
- Identified which demographics drove the highest seasonal sales.  

**3. Product performance**  
- Ranked **top-performing products** using `ROW_NUMBER()` and `RANK()` window functions.  
- Flagged **underperforming SKUs** to highlight inventory inefficiencies.  

**4. Regional insights**  
- Aggregated sales at **country and region level** to identify high-growth geographies.  
- Compared in-store vs. online sales channels, revealing adoption trends.  

**5. Payment methods**  
- Broke down purchases by **credit card, debit card, PayPal, and cash**.  
- Measured shifts in payment preferences across years.  

---

## Key techniques used

- **Window functions** (`ROW_NUMBER()`, `RANK()`, `LAG()`, `LEAD()`) → for trend comparisons and product rankings.  
- **Common Table Expressions (CTEs)** → to simplify multi-step aggregations.  
- **Aggregate functions** (`SUM`, `AVG`, `COUNT`) → to compute sales, revenue, cost, and profit.  
- **CASE statements** → for conditional grouping (e.g., age ranges, gender splits).  
- **Ordering & partitioning** → for year-over-year comparisons.  

---

## Insights delivered

- **Sales growth** → Measured Christmas sales growth year-over-year, highlighting peak periods.  
- **Customer behavior** → Identified **high-value customer groups** by age and gender.  
- **Profitability** → Found categories with the **highest margins**, guiding pricing strategy.  
- **Product mix** → Ranked **top 10 products by revenue** and flagged weak performers.  
- **Regional strategy** → Uncovered **fastest-growing regions**, shaping marketing efforts.  
- **Channel & payment** → Showed that **online and card-based payments** overtook cash/in-store sales over time.  

---

## Challenges I solved

- **Incomplete data periods** → Excluded 2017–2018 where full data wasn’t available, ensuring valid comparisons.  
- **Large aggregations** → Optimized queries with CTEs to make multi-step calculations manageable.  
- **Segmentation logic** → Designed CASE-based age/gender buckets to support flexible customer profiling.  
- **Complex rankings** → Applied window functions (`ROW_NUMBER`, `RANK`) to correctly identify top products across multiple partitions.  

---

✅ This project demonstrates my ability to **use SQL for end-to-end analytics**: from raw transaction data to business insights. It highlights skills in **data cleaning, aggregation, window functions, and segmentation**, producing insights that are directly actionable for **marketing, product, and strategy teams**.

