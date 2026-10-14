# Pharmaceutical Inventory Optimization & Financial Performance Analysis

**Tools:** Python · SQL Server · Power BI  
**Domain:** Pharmaceutical Supply Chain Analytics

## Overview
An end-to-end analytics project exploring inventory imbalances, demand variability, holding-cost exposure, and actual-versus-planned sales performance across a 250-product pharmaceutical portfolio.

**Dataset:** [Warehouse Cost Optimization — Pharmaceutical Company (Kaggle)](https://www.kaggle.com/datasets/kacperjarosik1/warehouse-cost-optimization-pharmaceutical-company)

## Business Questions
- Which products are understocked, healthy, or overstocked?
- Which products have severe or recurring inventory gaps?
- Which understocked products also have high demand variability?
- Which overstocked products have high holding costs or coverage exceeding shelf life?
- How do annual actual sales compare with planned units?

## Workflow
- **Python:** EDA, data cleaning, unpivoting, feature engineering, demand variability, inventory coverage, holding cost, inventory requirement, and stock-status classification.
- **SQL Server:** 10 business queries across inventory health, demand risk, and financial analysis using aggregations, CTEs, joins, views, `CROSS APPLY`, and variance calculations.
- **Power BI:** Power Query, DAX measures/calculated columns, KPI cards, trends, scatter plots, bookmarks, buttons and financial-plan comparisons.

## Dashboard Pages
1. **Inventory Health:** product count, sales, inventory, inventory value, stock-status distribution and trend.
<img width="374" height="207" alt="Screenshot 2026-10-14 171342" src="https://github.com/user-attachments/assets/a854e8b9-e380-44a9-83fa-912796b3255c" />

3. **High-Risk Products:** understocked/high-risk/overstocked KPIs, holding cost, inventory-gap and demand-risk visuals.
<img width="372" height="212" alt="Screenshot 2026-10-14 171406" src="https://github.com/user-attachments/assets/373ef514-3833-4d71-b2fd-2a171fba3a1b" />

4. **Financial Performance:** planned versus actual units and revenue, top 10 product-year sales variances, and annual actual-versus-plan comparison (2023–2025).
<img width="372" height="206" alt="Screenshot 2026-10-14 171428" src="https://github.com/user-attachments/assets/3aa1c185-4d82-4054-944f-608a5da29153" />


## Snapshot Findings
- Understocked: **55.01%**
- Overstocked: **23.98%**
- Healthy: **21.01%**
- Understocked products KPI: **164**
- Overstocked products KPI: **44**
- Dashboard holding-cost KPI: **359.42K** (currency and aggregation should be verified before interpretation)

These are current dashboard outputs. Product counts may vary with slicers and counting grain.

## Inventory Logic
- `Inventory requirement = Average monthly demand × (Safety-stock months + Lead-time months)`
- `Inventory gap = Available inventory − Inventory requirement`
- Demand variability is assessed using the coefficient of variation (CV).

Stock-status thresholds and measure definitions should be documented and validated. Coverage exceeding shelf life is a risk flag, not proof that stock will expire.

## Key Recommendations
- Prioritize severe and recurring shortages.
- Review replenishment assumptions using demand variability and lead time.
- Investigate overstocked products with high holding costs or potential shelf-life exposure.
- Investigate large actual-versus-planned sales deviations without assuming causation.
- Monitor inventory and financial KPIs regularly and measure results after changes.

## Skills Demonstrated
Python, pandas, NumPy, EDA, data cleaning, feature engineering, SQL Server, CTEs, joins, window functions, Power Query, DAX, KPI reporting, data visualization, variance analysis, and business recommendations.

## Limitations
The analysis is descriptive and does not prove causation or realized savings. Validate inventory thresholds, currency formatting, holding-cost aggregation, financial-plan alignment, and product-counting logic before using results for operational decisions.
