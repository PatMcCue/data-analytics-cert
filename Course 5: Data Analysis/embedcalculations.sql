/* Calculate totals of several columns and make it a new column called
Total_Bags_Calc
*/

SELECT
  Date,
  Region,
  Small_Bags,
  Large_Bags,
  XLarge_Bags,
  Total_Bags, 
  Small_Bags + Large_Bags + XLarge_Bags AS Total_Bags_Calc
FROM `data-analytics-435214.avocado_data.avocado_prices` 

/*
Find what percent of the total number of bags were small bags
WHERE statement is to fix "Divide by zero" error caused by
performing the selection only on rows where the total number of 
bags does not equal zero
*/

SELECT
	Date,
	Region,
	Total_Bags,
	Small_Bags,
	(Small_Bags / Total_Bags)*100 AS Small_Bags_Percent
FROM `data-analytics-435214.avocado_data.avocado_prices` 
WHERE
  Total_Bags <>0

