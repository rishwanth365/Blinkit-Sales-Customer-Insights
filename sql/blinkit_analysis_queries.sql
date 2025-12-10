use blinkitdb;

SELECT * FROM blinkit_data;
SELECT COUNT(*) FROM blinkit_data;

############## Data Cleaning ########################

SELECT DISTINCT(Item_Fat_Content) from blinkit_data;

SET SQL_SAFE_UPDATES=0;

UPDATE blinkit_data
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END;

SELECT DISTINCT(Item_Fat_Content) from blinkit_data;

########## DATA Analysis ####################################

### A. KPI's
SELECT CONCAT(CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)),' M') AS Total_Sales_in_Millions FROM blinkit_data;

SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,2)) AS AVG_Sales FROM blinkit_data;

SELECT COUNT(*) AS No_of_Orders FROM blinkit_data;

SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS AVG_Rating FROM blinkit_data;

###### B. Total Sales by Fat Content:

SELECT Item_Fat_Content,
	CONCAT(CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)),' K') AS Total_Sales_in_Thousands
FROM blinkit_data 
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_in_Thousands DESC;

############ C. Total Sales by Item Type

SELECT Item_Type,
	CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_in_Thousands
FROM blinkit_data 
GROUP BY Item_Type
ORDER BY Total_Sales_in_Thousands DESC;

############# D. Fat Content by Outlet for Total Sales
-- Pivot Low Fat vs Regular total sales by Outlet_Location_Type (MySQL)

SELECT
  Outlet_Location_Type,
  CAST(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Total_Sales ELSE 0 END)/1000 AS DECIMAL(10,2)) AS Low_Fat_Sales_in_Thousands,
  CAST(SUM(CASE WHEN Item_Fat_Content = 'Regular'  THEN Total_Sales ELSE 0 END)/1000 AS DECIMAL(10,2)) AS Regular_Sales_in_Thousands
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;

################### E. Total Sales by Outlet Establishment

SELECT Outlet_Establishment_Year,
	CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_in_Thousands
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

############# F. Percentage of Sales by Outlet Size

SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_in_Thousands,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales_in_Thousands DESC;

############## G. Sales by Outlet Location

SELECT Outlet_Location_Type, CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_in_Thousands
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales_in_Thousands DESC;

################# H. All Metrics by Outlet Type:

SELECT Outlet_Type,
CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_in_Thousands,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales_in_Thousands DESC;