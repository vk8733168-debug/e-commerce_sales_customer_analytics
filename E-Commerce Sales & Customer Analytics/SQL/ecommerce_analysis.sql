create database ecommerce_analytics;
use ecommerce_analytics;

-- =====================================================
-- E-COMMERCE SALES & CUSTOMER ANALYTICS
-- Database: MySQL
-- Table: ecommerce_orders_clean
-- =====================================================

-- =====================================================
--  PHASE 1 : Data Validation 
-- =====================================================

-- Query 1
# TOTAL RECORDS -----------
select count(*) as total_records
from ecommerce_orders_clean;

-- Query 2
# VIEW SAMPLE DATA -------
select * from ecommerce_orders_clean
limit 10;

-- Query 3
 # CHECK DATA RANGE ----------
select 
     Min(order_date) as first_order_date,
     Max(order_date) as last_order_date
from ecommerce_orders_clean;

-- Query 4
# CHECK UNIQUE CUSTOMERS ---------
select  
      count(distinct order_id) as total_orders
      from ecommerce_orders_clean;
     
-- Query 5      
# CHECK UNIQUE ORDERS -------
SELECT
    order_id,
    COUNT(*) AS order_count
FROM ecommerce_orders_clean
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC;

-- Query 6
# Null Values check  -------
SELECT
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(category IS NULL) AS null_category,
    SUM(price IS NULL) AS null_price,
    SUM(quantity IS NULL) AS null_quantity,
    SUM(order_date IS NULL) AS null_order_date,
    SUM(shipping_date IS NULL) AS null_shipping_date,
    SUM(delivery_status IS NULL) AS null_delivery_status,
    SUM(payment_method IS NULL) AS null_payment_method,
    SUM(device_type IS NULL) AS null_device_type,
    SUM(channel IS NULL) AS null_channel,
    SUM(customer_segment IS NULL) AS null_customer_segment,
    SUM(revenue IS NULL) AS null_revenue,
    SUM(shipping_days IS NULL) AS null_shipping_days
FROM ecommerce_orders_clean;

-- Query 7
# Basic Data Validation --------
select * from ecommerce_orders_clean where price <= 0;
select * from ecommerce_orders_clean where quantity <= 0;
select * from ecommerce_orders_clean where revenue <= 0;
select * from ecommerce_orders_clean where shipping_days < 0;

-- Query 8
# Category/ Status / Payment / Channel check ------------
select category , count(*) as orders from ecommerce_orders_clean 
group by category
order by orders desc;

-- Query 9
select delivery_status,count(*) as orders from ecommerce_orders_clean
group by delivery_status
order by orders desc;

-- Query 10
select payment_method , count(*) orders from ecommerce_orders_clean
group by payment_method
order by orders desc;

-- Query 11
select device_type,count(*) as orders from ecommerce_orders_clean 
group by device_type
order by orders;

-- Query 12
select channel,count(*) as orders from ecommerce_orders_clean
group by channel 
order by orders;

-- Query 13
select customer_segment,count(distinct customer_id) as customers from ecommerce_orders_clean
group by customer_segment
order by customers;

-- Query 14
# Revenue Calculation Check --------------
select count(*) as total_rows,sum(
                                  case
                                      when round(price*quantity,2) <> round(revenue,2)
                                      then 1 
                                      else 0
                                   end
								) as revenue_mismatch_rows
                                from ecommerce_orders_clean;

-- Query 15                                
# Shipping Date Validation--------
Select count(*) as invalid_shipping_dates
from ecommerce_orders_clean
where shipping_date < order_date;   

-- =====================================================
--   PHASE 2 : SALES PERFORMANCE ANALYSIS 
-- =====================================================

-- Query 1
# OVERALL SALES KPIs -----------------
SELECT
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM ecommerce_orders_clean;

-- Query 2
# MONTHLY REVENUE AND ORDERS ------------
SELECT order_month,round(sum(revenue),2) as total_revenue,
count(distinct order_id) as total_orders,
count(distinct customer_id) as total_customers,
sum(quantity) as total_quantity
from ecommerce_orders_clean
group by order_month
order by order_month;

-- Query 3
# REVENEUE BY CATEGORY -----------
SELECT
    category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(revenue), 2) AS average_revenue
FROM ecommerce_orders_clean
GROUP BY category
ORDER BY total_revenue DESC;

-- Query 4
# CATEGORY REVENUE CONTRBUTION % --------------
SELECT
    category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) * 100 /
        (SELECT SUM(revenue) FROM ecommerce_orders_clean),
        2
    ) AS revenue_percentage
FROM ecommerce_orders_clean
GROUP BY category
ORDER BY total_revenue DESC;

-- Query 5                   
# TOP 10 PRDOUCTS ------------
SELECT
    product_id,
    category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_orders_clean
GROUP BY product_id, category
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 6
# BOTTOM 10 PRDOUCTS ----------
SELECT
    product_id,
    category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_orders_clean
GROUP BY product_id, category
ORDER BY total_revenue ASC
LIMIT 10;

-- Query 7           
# TOP 10 CUSTOMERS BY REVENUE -----
SELECT
    customer_id,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity
FROM ecommerce_orders_clean
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;           

-- Query 8
# CUSTOMER SEGMENT PERFORMANCE ---------
SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) / COUNT(DISTINCT customer_id), 2
    ) AS revenue_per_customer
FROM ecommerce_orders_clean
GROUP BY customer_segment
ORDER BY total_revenue DESC;

-- Query 9
# REVENUE BY PAYMENT METHOD -----------
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS average_order_value
FROM ecommerce_orders_clean
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Query 10
# REVENUE BY DEVICE TYPES ----------
SELECT
    device_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS average_order_value
FROM ecommerce_orders_clean
GROUP BY device_type
ORDER BY total_revenue DESC;

-- Query 11
# REVENUE BY SALES CHANNEL -------- 
SELECT
    channel,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS average_order_value
FROM ecommerce_orders_clean
GROUP BY channel
ORDER BY total_revenue DESC;

-- =====================================================
--  PHASE 3 : DELIVERY AND SHIPPING ANALYTICS
-- =====================================================

-- Query 1 
# DELIVERY STATUS PERFORMANCE -------- 
SELECT
    delivery_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0 /
        (SELECT COUNT(DISTINCT order_id)
         FROM ecommerce_orders_clean),
        2
    ) AS order_percentage
FROM ecommerce_orders_clean
GROUP BY delivery_status
ORDER BY total_orders DESC;

-- Query 2
# AVERAGE SHIPPING DAYS BY DELIVERY STATUS --------------
SELECT
    delivery_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days,
    MIN(shipping_days) AS min_shipping_days,
    MAX(shipping_days) AS max_shipping_days
FROM ecommerce_orders_clean
GROUP BY delivery_status
ORDER BY avg_shipping_days;

-- Query 3
# MONTHLY SHIPPING PERFORMANCE ---------
SELECT
    order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(shipping_days), 2) AS avg_shipping_days,
    SUM(
        CASE
            WHEN delivery_status = 'Delivered' THEN 1
            ELSE 0
        END
    ) AS delivered_orders
FROM ecommerce_orders_clean
GROUP BY order_month
ORDER BY order_month;

-- Query 4
# DELIVERY STATUS X CUSTOMER SEGMENT -------
SELECT
    customer_segment,
    delivery_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_orders_clean
GROUP BY
    customer_segment,
    delivery_status
ORDER BY
    customer_segment,
    total_orders DESC;

-- Query 5    
# SHIPPING DAYS DISTRIBUTION ---------
SELECT
    CASE
        WHEN shipping_days <= 2 THEN '0-2 Days'
        WHEN shipping_days <= 5 THEN '3-5 Days'
        WHEN shipping_days <= 7 THEN '6-7 Days'
        ELSE '8+ Days'
    END AS shipping_bucket,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_orders_clean
GROUP BY
    CASE
        WHEN shipping_days <= 2 THEN '0-2 Days'
        WHEN shipping_days <= 5 THEN '3-5 Days'
        WHEN shipping_days <= 7 THEN '6-7 Days'
        ELSE '8+ Days'
    END
ORDER BY total_orders DESC;    
 -- =====================================================                      
--   PHASE 4A : ADVANCED CUSTOMER ANALYSIS 
-- =====================================================

-- Query 1
# CUSTOMER PURCHASE SUMMARY-----------
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM ecommerce_orders_clean
GROUP BY customer_id
ORDER BY total_revenue DESC;

-- Query 2
# ONE-TIME VS REPEAT CUSTOMERS--------
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM ecommerce_orders_clean
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM customer_orders),
        2
    ) AS customer_percentage
FROM customer_orders
GROUP BY
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END;

-- Query 3 					
# REVENUE FROM ONE - TIME VS REPEAT CUSTOMERS--------
WITH customer_summary AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(revenue) AS total_revenue
    FROM ecommerce_orders_clean
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM customer_summary
GROUP BY
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END;
-- =====================================================    
-- PHASE 4B : RFM ANALYSIS
-- =====================================================

-- Query 1
 # CREATE RFM BASE TABLE--------
 WITH converted_data AS (
    SELECT
        customer_id,
        order_id,
        revenue,
        STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date
    FROM ecommerce_orders_clean
)

SELECT
    customer_id,
    DATEDIFF(
        (SELECT MAX(order_date) FROM converted_data),
        MAX(order_date)
    ) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    ROUND(SUM(revenue), 2) AS monetary
FROM converted_data
GROUP BY customer_id
ORDER BY monetary DESC;

-- Query 2
# RFM SCORES -------
WITH converted_data AS (
    SELECT
        customer_id,
        order_id,
        revenue,
        STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date
    FROM ecommerce_orders_clean
),

rfm AS (
    SELECT
        customer_id,
        DATEDIFF(
            (SELECT MAX(order_date) FROM converted_data),
            MAX(order_date)
        ) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        ROUND(SUM(revenue), 2) AS monetary
    FROM converted_data
    GROUP BY customer_id
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,

    NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,

    NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,

    NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score

FROM rfm;

-- Query 3
# FINAL RFM SCORES -------
WITH converted_data AS (
    SELECT
        customer_id,
        order_id,
        revenue,
        STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date
    FROM ecommerce_orders_clean
),

rfm AS (
    SELECT
        customer_id,
        DATEDIFF(
            (SELECT MAX(order_date) FROM converted_data),
            MAX(order_date)
        ) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        ROUND(SUM(revenue), 2) AS monetary
    FROM converted_data
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
    FROM rfm
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score
FROM rfm_scores;

-- Query 4
# CUSTOMER SEGMENTATION  --------
WITH converted_data AS (
    SELECT
        customer_id,
        order_id,
        revenue,
        STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date
    FROM ecommerce_orders_clean
),

rfm AS (
    SELECT
        customer_id,
        DATEDIFF(
            (SELECT MAX(order_date) FROM converted_data),
            MAX(order_date)
        ) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        ROUND(SUM(revenue), 2) AS monetary
    FROM converted_data
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS R,
        NTILE(5) OVER (ORDER BY frequency ASC) AS F,
        NTILE(5) OVER (ORDER BY monetary ASC) AS M
    FROM rfm
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    R,
    F,
    M,

    CASE
        WHEN R >= 4 AND F >= 4 AND M >= 4
            THEN 'Champions'

        WHEN R >= 3 AND F >= 4 AND M >= 3
            THEN 'Loyal Customers'

        WHEN R >= 4 AND F <= 3 AND M <= 3
            THEN 'Potential Loyalists'

        WHEN R <= 2 AND F >= 3 AND M >= 3
            THEN 'At Risk'

        WHEN R <= 2 AND F <= 2 AND M <= 2
            THEN 'Lost Customers'

        ELSE 'Others'
    END AS customer_segment

FROM rfm_scores;

-- Query 5
# RFM SEGMENT SUMMARY -----
WITH converted_data AS (
    SELECT
        customer_id,
        order_id,
        revenue,
        STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date
    FROM ecommerce_orders_clean
),

rfm AS (
    SELECT
        customer_id,
        DATEDIFF(
            (SELECT MAX(order_date) FROM converted_data),
            MAX(order_date)
        ) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        ROUND(SUM(revenue), 2) AS monetary
    FROM converted_data
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS R,
        NTILE(5) OVER (ORDER BY frequency ASC) AS F,
        NTILE(5) OVER (ORDER BY monetary ASC) AS M
    FROM rfm
),

segmented_customers AS (
    SELECT
        *,
        CASE
            WHEN R >= 4 AND F >= 4 AND M >= 4
                THEN 'Champions'
            WHEN R >= 3 AND F >= 4 AND M >= 3
                THEN 'Loyal Customers'
            WHEN R >= 4 AND F <= 3 AND M <= 3
                THEN 'Potential Loyalists'
            WHEN R <= 2 AND F >= 3 AND M >= 3
                THEN 'At Risk'
            WHEN R <= 2 AND F <= 2 AND M <= 2
                THEN 'Lost Customers'
            ELSE 'Others'
        END AS rfm_segment
    FROM rfm_scores
)

SELECT
    rfm_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(AVG(monetary), 2) AS avg_customer_revenue,
    ROUND(AVG(recency), 2) AS avg_recency,
    ROUND(AVG(frequency), 2) AS avg_frequency
FROM segmented_customers
GROUP BY rfm_segment
ORDER BY total_revenue DESC;

-- Query 6
# SEGMENT REVENUE CONTRIBUTION % -------
WITH converted_data AS (
    SELECT
        customer_id,
        order_id,
        revenue,
        STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date
    FROM ecommerce_orders_clean
),

rfm AS (
    SELECT
        customer_id,
        DATEDIFF(
            (SELECT MAX(order_date) FROM converted_data),
            MAX(order_date)
        ) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(revenue) AS monetary
    FROM converted_data
    GROUP BY customer_id
),

rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency DESC) AS R,
        NTILE(5) OVER (ORDER BY frequency ASC) AS F,
        NTILE(5) OVER (ORDER BY monetary ASC) AS M
    FROM rfm
),

segmented_customers AS (
    SELECT
        *,
        CASE
            WHEN R >= 4 AND F >= 4 AND M >= 4 THEN 'Champions'
            WHEN R >= 3 AND F >= 4 AND M >= 3 THEN 'Loyal Customers'
            WHEN R >= 4 AND F <= 3 AND M <= 3 THEN 'Potential Loyalists'
            WHEN R <= 2 AND F >= 3 AND M >= 3 THEN 'At Risk'
            WHEN R <= 2 AND F <= 2 AND M <= 2 THEN 'Lost Customers'
            ELSE 'Others'
        END AS rfm_segment
    FROM rfm_scores
)

SELECT
    rfm_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(
        SUM(monetary) * 100.0 /
        (SELECT SUM(monetary) FROM segmented_customers),
        2
    ) AS revenue_contribution_pct
FROM segmented_customers
GROUP BY rfm_segment
ORDER BY total_revenue DESC;

-- =====================================================
--  PHASE 5 : FINAL BUSINESS ANALYSIS
-- =====================================================

-- Query 1
# SALES CHANNEL PERFORMANCE -----------
SELECT
    channel,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) / COUNT(DISTINCT order_id), 2
    ) AS avg_order_value
FROM ecommerce_orders_clean
GROUP BY channel
ORDER BY total_revenue DESC;

-- Query 2
# DEVICE PERFOMANCE --------
SELECT
    device_type,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue
FROM ecommerce_orders_clean
GROUP BY device_type
ORDER BY total_revenue DESC;

-- Query 3
# PAYMENT METHOD PERFORMANCE ----------
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(revenue) * 100.0 /
        (SELECT SUM(revenue)
         FROM ecommerce_orders_clean),
        2
    ) AS revenue_percentage
FROM ecommerce_orders_clean
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- Query 4
# CATEGORY x CUSTOMER SEGMENT --------
SELECT
    category,
    customer_segment,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_orders_clean
GROUP BY
    category,
    customer_segment
ORDER BY
    category,
    total_revenue DESC;

-- Query 5    
# MONTHLY REVENUE GROWTH ------
WITH monthly_sales AS (
    SELECT
        order_month,
        SUM(revenue) AS total_revenue
    FROM ecommerce_orders_clean
    GROUP BY order_month
)

SELECT
    order_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        LAG(total_revenue) OVER (ORDER BY order_month),
        2
    ) AS previous_month_revenue,
    ROUND(
        (
            total_revenue -
            LAG(total_revenue) OVER (ORDER BY order_month)
        ) * 100.0 /
        LAG(total_revenue) OVER (ORDER BY order_month),
        2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY order_month;  

-- Query 6
# TOP 10 CUSTOMERS --- RANKING -----------
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(revenue) AS total_revenue
    FROM ecommerce_orders_clean
    GROUP BY customer_id
)

SELECT
    customer_id,
    ROUND(total_revenue, 2) AS total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS customer_rank
FROM customer_sales
ORDER BY customer_rank
LIMIT 10;  

-- Query 7
# HIGHEST BUSINESS INSIGHTS -------
SELECT
    category,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_orders_clean
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 1;

-- Query 8
# BEST SALES CHANNEL -----
SELECT
    channel,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_orders_clean
GROUP BY channel
ORDER BY total_revenue DESC
LIMIT 1;

-- Query 9
# MOST USED PAYMENT METHOD ------
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_orders_clean
GROUP BY payment_method
ORDER BY total_orders DESC
LIMIT 1;

-- Query 10
# MOST USED DEVICE -------
SELECT
    device_type,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_orders_clean
GROUP BY device_type
ORDER BY total_orders DESC
LIMIT 1;

-- Query 11
# BEST PERFORMING CUSTOMER SEGMENT -----------
SELECT
    customer_segment,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(DISTINCT customer_id) AS total_customers
FROM ecommerce_orders_clean
GROUP BY customer_segment
ORDER BY total_revenue DESC
LIMIT 1;

-- Query 12
# AVG DELIVERY TIME ----------
SELECT
    ROUND(AVG(shipping_days), 2) AS average_shipping_days
FROM ecommerce_orders_clean;

-- Query 13
# DELIVERY STATUS SUMMARY ------- 
SELECT
    delivery_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0 /
        (SELECT COUNT(DISTINCT order_id)
         FROM ecommerce_orders_clean),
        2
    ) AS order_percentage
FROM ecommerce_orders_clean
GROUP BY delivery_status
ORDER BY total_orders DESC;