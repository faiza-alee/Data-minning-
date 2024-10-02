create database retailshop;

use retailshop;


select * from online_retail;

 --          What is the distribution of order values across all customers in the dataset?
select CustomerID,
SUM(UnitPrice * Quantity) AS TotalOrders
from  online_retail
group by CustomerID
order by TotalOrders;

--         How many unique products has each customer purchased?

select CustomerID,
count(distinct InvoiceNo) AS UniqueProductsPurchased
from  online_retail
group by CustomerID;

-- •        Which customers have only made a single purchase from the company?
select CustomerID
from  online_retail
group by CustomerID
having count(distinct StockCode)=1;

-- •        Which products are most commonly purchased together by customers in the dataset? 
 SELECT p1.StockCode AS Product1, p2.StockCode AS Product2, COUNT(*) AS PairCount
FROM online_retail p1
JOIN online_retail p2 
  ON p1.InvoiceNo = p2.InvoiceNo 
 AND p1.StockCode != p2.StockCode
GROUP BY p1.StockCode, p2.StockCode
ORDER BY PairCount DESC;


-- Advance Queries

-- 1. Customer Segmentation by Purchase Frequency
-- Group customers into segments based on their purchase frequency, such as high, medium, and low frequency customers.
--  This can help you identify your most loyal customers and those who need more attention.
SELECT CustomerID, 
       COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency,
       CASE 
          WHEN COUNT(DISTINCT InvoiceNo) > 10 THEN 'High Frequency'
          WHEN COUNT(DISTINCT InvoiceNo) BETWEEN 5 AND 10 THEN 'Medium Frequency'
          ELSE 'Low Frequency'
       END AS FrequencySegment
FROM online_retail
GROUP BY CustomerID;

-- 2. Average Order Value by Country
-- Calculate the average order value for each country to identify where your most valuable customers are located.
 SELECT Country, 
       AVG(Quantity * UnitPrice) AS AvgOrderValue
FROM online_retail
GROUP BY Country
ORDER BY AvgOrderValue DESC;
 
-- 3. Customer Churn Analysis
--  Identify customers who haven't made a purchase in a specific period (e.g., last 6 months) to assess churn.
 SELECT CustomerID
FROM online_retail
WHERE InvoiceDate < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY CustomerID
HAVING MAX(InvoiceDate) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
 
--  4. Product Affinity Analysis
-- Determine which products are often purchased together by calculating the correlation between product purchases.
SELECT p1.StockCode AS Product1, p2.StockCode AS Product2, COUNT(*) AS PairCount
FROM online_retail p1
JOIN online_retail p2 
  ON p1.InvoiceNo = p2.InvoiceNo 
 AND p1.StockCode != p2.StockCode
GROUP BY p1.StockCode, p2.StockCode
ORDER BY PairCount DESC;
 
-- 5. Time-based Analysis
-- Explore trends in customer behavior over time, such as monthly or quarterly sales patterns.

--  Monthly Sales:
SELECT YEAR(InvoiceDate) AS Year, MONTH(InvoiceDate) AS Month, SUM(Quantity * UnitPrice) AS TotalSales
FROM online_retail
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year, Month;

--  Quarterly Sales:
SELECT YEAR(InvoiceDate) AS Year, QUARTER(InvoiceDate) AS Quarter, SUM(Quantity * UnitPrice) AS TotalSales
FROM online_retail
GROUP BY YEAR(InvoiceDate), QUARTER(InvoiceDate)
ORDER BY Year, Quarter;

