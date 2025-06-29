# Customer Segmentation Dashboard: RFM Analysis with SQL + Power BI

🔍 **Project Overview**
This project aims to analyze customer behavior using the RFM (Recency, Frequency, Monetary) model. The final Power BI dashboard provides insights into customer value segmentation based on transactional data from the [UCI Online Retail Dataset].

🧩**RFM Model Logic**
Recency → Days since last purchase

Frequency → Number of unique invoices

Monetary → Total revenue from each customer

🛠 **Tech Stack**
SQL (MySQL Workbench) – For data cleaning, transformation, and RFM scoring

Power BI – For creating interactive dashboards

Excel – Initial data filtering and date formatting

⚙️ **Project Steps**
**Data Cleaning in Excel**

Removed canceled invoices (InvoiceNo starts with "C")

Removed rows with blank CustomerID, Quantity <= 0

Reformatted InvoiceDate to YYYY-MM-DD HH:MM:SS format

**SQL (RFM Analysis)**

Created tables for Recency, Frequency, and Monetary

Used NTILE(5) for scoring

Merged into RFM_Scored and created customer segments

**Power BI Visualizations**

Segment Distribution Pie

Average Revenue by Segment

Recency, Frequency, Monetary Distributions

Matrix of R/F Scores

Country-wise Segment Bar

Top 10 Customers by Score

Full RFM Score Table with Segment

