-- Shows how products perform across time (monthly).
CREATE VIEW vw_product_seasonality AS
SELECT
  TO_CHAR(o.Order_Date, 'YYYY-MM') AS Month,
  p.Product_ID,
  p.Product_Name,
  SUM(f.Quantity) AS Total_Units_Sold,
  SUM(f.Total_Sales) AS Total_Revenue
FROM FactSales f
JOIN DimOrder o ON f.Order_ID = o.Order_ID
JOIN DimProduct p ON f.Product_ID = p.Product_ID
GROUP BY Month, p.Product_ID, p.Product_Name
ORDER BY Month, Total_Revenue DESC;
SELECT * FROM vw_product_seasonality

-- Examines the relationship between discount levels and profit.
CREATE VIEW vw_discount_impact_analysis AS
SELECT
  ROUND(f.Discount, 2) AS Discount_Rate,
  COUNT(*) AS Num_Transactions,
  SUM(f.Total_Sales) AS Total_Revenue,
  SUM(f.Profit) AS Total_Profit,
  ROUND(AVG(f.Profit), 2) AS Avg_Profit_Per_Transaction
FROM FactSales f
GROUP BY Discount_Rate
ORDER BY Discount_Rate;
SELECT * FROM vw_discount_impact_analysis

-- Tracks behavior by customer: order frequency, average order value, and profit
DROP VIEW IF EXISTS vw_customer_order_patterns;

CREATE VIEW vw_customer_order_patterns AS
SELECT
  f.Customer_ID,
  p.Segment,
  COUNT(DISTINCT f.Order_ID) AS Order_Count,
  ROUND(SUM(f.Total_Sales) / NULLIF(COUNT(DISTINCT f.Order_ID), 0), 2) AS Avg_Order_Value,
  ROUND(SUM(f.Total_Profit), 2) AS Total_Profit
FROM FactSales f
JOIN DimProduct p ON f.Product_ID = p.Product_ID
GROUP BY f.Customer_ID, p.Segment;


SELECT * FROM vw_customer_order_patterns

-- Compares profits between online and in-store sales.
CREATE VIEW vw_channel_margin_report AS
SELECT
  o.Order_Mode,
  COUNT(*) AS Transactions,
  SUM(f.Total_Sales) AS Total_Revenue,
  SUM(f.Total_Profit) AS Total_Profit,
  ROUND(SUM(f.Total_Profit) / NULLIF(SUM(f.Total_Sales), 0), 4) AS Profit_Margin
FROM FactSales f
JOIN DimOrder o ON f.Order_ID = o.Order_ID
GROUP BY o.Order_Mode;
SELECT * FROM vw_channel_margin_report

-- Ranks categories by profit margin in each region.
CREATE VIEW vw_category_rankings AS
SELECT
  p.Category,
  SUM(f.Total_Profit) AS Total_Profit,
  ROUND(SUM(f.Total_Profit) / NULLIF(SUM(f.Total_Sales), 0), 4) AS Profit_Margin,
  RANK() OVER (ORDER BY SUM(f.Total_Profit) DESC) AS Category_Rank
FROM FactSales f
JOIN DimProduct p ON f.Product_ID = p.Product_ID
GROUP BY p.Category;
SELECT * FROM vw_category_rankings