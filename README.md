# BANKING-TRANSACTION-CREDIT-RISK-ANALYTICS
## Tech Stack & Methodology
* Database & SQL Engineering: PostgreSQL, DBeaver (DDL Table Creation, Multi-table Joins, Aggregated Views)
* Data Analytics & Risk Modeling: PostgreSQL (Conditional Aggregations, Window Functions, Credit Risk Segmentation)
* Data Visualization & Dashboarding: Power BI Desktop (Import Mode, Custom Themes, Interactive Slicers)
* DAX Modeling: 3-Tier DAX Architecture (`_Measures` Table for Base, Diagnostic, and Risk Exposure Metrics)



## Data Cleaning, SQL Engineering & Data Mart Design

### Key Database & Preprocessing Steps (PostgreSQL):
* Schema Definition & DDL Creation: Engineered relational schemas with explicit Primary/Foreign Key constraints across dimension tables (`DimCustomer`, `DimAccount`, `DimProductCategory`, `DimProductSubCategory`, `DimProduct`) and transaction fact table (`FactTransaction`).
* Analytical Data Mart Views:
  * `v_fact_transactions_analytics`: Integrated transaction logs with account and customer demographics via `LEFT JOIN` to optimize Power BI Import Mode query performance.
  * `v_customer_credit_risk`: Aggregated total credit balance per customer and computed dynamic credit risk tiers (`High Risk (Negative Balance)` vs. `Normal Risk`).
* Risk Feature Engineering:
  * Categorized account balances (`SUM(CASE WHEN AccountType = 'Credit' THEN Balance ELSE 0 END)`).
  * Flagged credit accounts with cumulative balance < $0 for proactive loss monitoring.

---

## 3-Tier DAX Architecture (`_Measures`)

All measures were systematically developed and isolated within a dedicated `_Measures` table following a 3-Tier DAX Architecture:

* Tier 1: Base Measures
  * `Total Volume` = `SUM('v_fact_transactions_analytics'[TransactionAmount])`
  * `Total Txns` = `COUNTROWS('v_fact_transactions_analytics')`
  * `Total Credit (Inflow)` = `CALCULATE([Total Volume], 'v_fact_transactions_analytics'[TransactionType] = "Credit")`
  * `Total Debit (Outflow)` = `CALCULATE([Total Volume], 'v_fact_transactions_analytics'[TransactionType] = "Debit")`

* Tier 2: Diagnostic & Operational Metrics
  * `Net Cash Flow` = `[Total Credit] - [Total Debit]`
  * `Failed Txns` = `CALCULATE([Total Txns], 'v_fact_transactions_analytics'[TransactionStatus] = "Failed")`
  * `Failed Rate (%)` = `DIVIDE([Failed Txns], [Total Txns], 0)`

* Tier 3: Risk Exposure Metrics
  * `Total Negative Balance` = `CALCULATE(SUM('v_customer_credit_risk'[TotalCreditBalance]), 'v_customer_credit_risk'[TotalCreditBalance] < 0)`

---

## 💡 Key Business Insights

* System Failure Bottlenecks in Mobile Channel: Audited system transaction failure rate stands at 4.67%. Over 60% of all failed transactions** are concentrated in the Mobile channel, highlighting server response timeouts or payment gateway integration issues.
* Capital Outflow / Liquidity Stress: Net Cash Flow across audited transactions shows a heavy negative deficit (-$25.02M), driven by significantly higher Debit withdrawal volumes compared to Credit deposits.
* **Credit Default Risk Concentration:**
  * 31 out of 100 customers (31%) maintain negative credit balances, placing them in the High Risk segment.
  * Aggregate credit default risk exposure reaches -$180.40K in cumulative negative credit balance**.
* Regional Risk Concentration: Accounts exhibiting severe default vulnerability show high geographic concentration in specific regions (e.g., Utah, Colorado).

---

## 📊 Power BI Interactive Dashboard

The interactive Power BI dashboard is structured into 3 core functional zones:

* Executive KPI Cards (Top Banner):
  * Total Volume ($5.22M)
  * Net Cash Flow (-$25.02M)
  * Failed Rate (4.67%)
  * Total Negative Credit Exposure (-$180.40K)
* Core Operational & Risk Visuals:
  * Transactions & Failures by Channel: Clustered bar chart breaking down success vs. failure counts across Mobile, Web, and ATM gateways.
  * Customer Risk Distribution: Donut chart showcasing customer breakdown between Normal Risk vs. High Risk (Negative Balance) segments.
  * Top Customers by Negative Balance: Detail table displaying high-exposure delinquent accounts (e.g., default balances ranging up to -$13.04K).
* Interactive Slicers & Filters:
  * Geographic Region Filter (Multi-select dropdown)
  * Customer & Account Status Toggles (Active, Inactive, Suspended)

---

## 🎯 Actionable Recommendations

* Mobile API Gateway Audit: Perform immediate technical root-cause analysis on the Mobile payment gateway to mitigate connection drop-offs and reduce the system-wide 4.67% failure rate.
* Credit Exposure Threshold Controls: Institute automated account lock triggers for credit lines dropping below -$4,000 in balance to halt default escalation.
