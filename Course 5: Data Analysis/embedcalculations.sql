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

/* EXTRACT function pulls out just the year from the entire date listed
*/

SELECT 
  EXTRACT(YEAR FROM starttime) AS year,
  COUNT(*) AS number_of_rides
FROM
  `bigquery-public-data.new_york_citibike.citibike_trips` 
GROUP BY
  year
ORDER BY
  year DESC

/* Using subtraction operator to find the difference in ridership between
years
*/

SELECT 
  station_name,
  ridership_2013,
  ridership_2014,
  ridership_2014-ridership_2013 AS change_2014_raw
FROM 
  `bigquery-public-data.new_york_subway.subway_ridership_2013_present` 

/*
Using division operator instead of AVG function to find average
ridership over four years at each station
*/

SELECT 
  station_name,
  ridership_2013,
  ridership_2014,
  ridership_2015,
  ridership_2016,
  (ridership_2013 + ridership_2014 + ridership_2015 + ridership_2016)/4
FROM 
  `bigquery-public-data.new_york_subway.subway_ridership_2013_present` 
