# E-Commerce Sales & Customer Analytics

## 📌 Project Overview

This project analyzes e-commerce sales, customer behavior, product performance, and operational metrics using SQL and Power BI.

The goal is to transform raw e-commerce transaction data into meaningful business insights and an interactive dashboard that can support data-driven decision making.

---

## 🎯 Business Objectives

- Analyze overall sales and revenue performance
- Identify top-performing products and categories
- Understand customer purchasing behavior
- Identify repeat and one-time customers
- Analyze customer segments
- Evaluate delivery and shipping performance
- Analyze revenue by payment method, sales channel, and device type
- Build an interactive business dashboard

---

## 🗂️ Dataset

The dataset contains approximately 10,000 e-commerce transaction records.

### Main Columns

- Customer ID
- Order ID
- Product ID
- Category
- Price
- Quantity
- Order Date
- Shipping Date
- Delivery Status
- Payment Method
- Device Type
- Channel
- Customer Segment
- Revenue
- Shipping Days
- Order Month

---

## 🛠️ Tools & Technologies

- **MySQL**
- **SQL**
- **Power BI**
- **DAX**
- **CSV**
- **GitHub**

---

## 📊 Key KPIs

The Power BI dashboard tracks:

- Total Revenue
- Total Orders
- Total Customers
- Total Quantity
- Average Order Value
- Repeat Customers
- One-Time Customers
- Repeat Customer %
- Average Shipping Days
- Delivered Orders
- Delivery Success %

---

## 📈 Dashboard Pages

### 1. Executive Sales Overview

Provides a high-level overview of business performance.

Key analysis:

- Monthly Revenue Trend
- Revenue by Category
- Revenue by Sales Channel
- Revenue by Customer Segment
- Revenue by Payment Method

![Executive Sales Overview](Screenshots/Executive_Sales_Overview.png)

---

### 2. Customer Analytics

Focuses on customer behavior and customer contribution.

Key analysis:

- Customers by Segment
- Revenue by Customer Segment
- Top 10 Customers by Revenue
- Revenue Contribution by Customer Segment
- Repeat vs One-Time Customers
- Customer Orders vs Revenue

![Customer Analytics](Screenshots/Customer_Analytics.png)

---

### 3. Product & Operations Analytics

Analyzes product performance and operational efficiency.

Key analysis:

- Top 10 Products by Revenue
- Quantity Sold by Category
- Orders by Delivery Status
- Average Shipping Days by Category
- Revenue by Payment Method
- Revenue by Device Type

![Product & Operations Analytics](Screenshots/Product_Operations_Analytics.png)

---

## 🔍 SQL Analysis

SQL was used for:

- Data validation
- Data quality checks
- Sales analysis
- Customer analysis
- Product analysis
- Operations analysis
- RFM analysis
- Business performance analysis

The complete SQL queries are available in:

`SQL/ecommerce_analysis.sql`

---

## 📁 Project Structure

```text
E-Commerce Sales & Customer Analytics
│
├── Data
│   └── ecommerce_orders_clean.csv
│
├── SQL
│   └── ecommerce_analysis.sql
│
├── PowerBI
│   └── E-Commerce_Sales_Customer_Analytics.pbix
│
├── Screenshots
│   ├── Executive_Sales_Overview.png
│   ├── Customer_Analytics.png
│   └── Product_Operations_Analytics.png
│
└── README.md
