-- REUSEABLE QUERIES OUTSIDE VIEW

-- Total Sales and Profit by Product Category
SELECT 
  p.Category,
  SUM(f.Total_Sales) AS Total_Revenue,
  SUM(f.Total_Profit) AS Total_Profit
FROM FactSales f
JOIN DimProduct p ON f.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Products with High Quantity but Low Profit
SELECT 
  p.Product_Name,
  SUM(f.Quantity) AS Total_Units,
  SUM(f.Total_Profit) AS Total_Profit
FROM FactSales f
JOIN DimProduct p ON f.Product_ID = p.Product_ID
GROUP BY p.Product_Name
HAVING SUM(f.Quantity) > 50 AND SUM(f.Total_Profit) < 100
ORDER BY Total_Units DESC;

-- Top 10 Best-Selling Products by Quantity
SELECT 
  p.Product_Name,
  SUM(f.Quantity) AS Total_Units_Sold
FROM FactSales f
JOIN DimProduct p ON f.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Units_Sold DESC
LIMIT 10;

-- Profitability by Sales Channel (Online vs In-Store)
SELECT 
  o.Order_Mode,
  SUM(f.Total_Sales) AS Revenue,
  SUM(f.Total_Profit) AS Profit,
  ROUND(SUM(f.Total_Profit) / NULLIF(SUM(f.Total_Sales), 0), 4) AS Profit_Margin
FROM FactSales f
JOIN DimOrder o ON f.Order_ID = o.Order_ID
GROUP BY o.Order_Mode;

-- Customer Profit Contribution (Top 10 Customers)
SELECT 
  f.Customer_ID,
  COUNT(DISTINCT f.Order_ID) AS Orders,
  SUM(f.Total_Sales) AS Revenue,
  SUM(f.Total_Profit) AS Profit
FROM FactSales f
GROUP BY f.Customer_ID
ORDER BY Profit DESC
LIMIT 10;