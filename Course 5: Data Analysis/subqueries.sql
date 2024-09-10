/* Run a query within a query to drill down on a certain column
Used to build "more complex" queries, put them in ()
In this query, you will compare the number of bikes available at a particular station 
to the overall average number of bikes available at all stations.
The sub-query on line 10 is used to make a new column that is not available on the original table
*/
SELECT
	station_id,
	num_bikes_available,
	(SELECT
		AVG(num_bikes_available)
	FROM bigquery-public-data.new_york.citibike_stations) AS avg_num_bikes_available
FROM bigquery-public-data.new_york.citibike_stations;

/* Use a sub-query in a FROM statement
Use the citibike_trips table to calculate the total number of rides that started 
at each station and return this as a column called number_of_rides_starting_at_station
 along with the columns station_id and name from the citibike_stations table. 
The lines with #**, ignore that, it just differed from the video
*/

SELECT 
	station_id,
	name,
	number_of_rides AS number_of_rides_starting_at_station
FROM
	(
		SELECT
			CAST(start_station_id AS STRING) AS start_station_id_str, #**
			COUNT(*) AS number_of_rides
		FROM 
      		bigquery-public-data.new_york.citibike_trips
		GROUP BY 
			CAST(start_station_id AS STRING) #**
	)
	AS station_num_trips
	INNER JOIN 
		bigquery-public-data.new_york.citibike_stations 
	ON 
		station_id = start_station_id_str #**
	ORDER BY 
		number_of_rides DESC;

/* Write a query that returns a table containing two columns: the station_id and 
name (from the citibike_stations table) of only those stations that were used by 
people classified as subscribers, which is information found in the citibike_trips 
table.  

*/

SELECT
	station_id,
	name
FROM
	bigquery-public-data.new_york.citibike_stations
WHERE
	station_id IN
	(
		SELECT
			CAST(start_station_id AS STRING) AS start_station_id_str #**
		FROM
	    	bigquery-public-data.new_york.citibike_trips
	  	WHERE
			usertype = 'Subscriber'
  	);

/* Find the average trip duration for a particular station
This SELECT statement is used to create the outer query. The fields identified 
in lines 2 and 3 allow the SELECT statement to function similarly to a table 
with an alias, e.g. SELECT alias.column_name1, alias.column_name2. This relies 
on the sub-query below to populate the Query results table.
*/

SELECT
  subquery.start_station_id,
  subquery.avg_duration
FROM
  (
  SELECT
    start_station_id,
    AVG(tripduration) AS avg_duration
  FROM bigquery-public-data.new_york_citibike.citibike_trips
  GROUP BY start_station_id) AS subquery
  ORDER BY avg_duration DESC;

/* Create a new query to compare the average trip duration per station to the overall
 average trip duration from all stations. This will provide insights about how long 
 people typically use the bikes that they get from a particular station in comparison 
 to the overall average.
A SELECT statement is used to begin a sub-query that will 
return the average trip duration for each station.
A second SELECT statement is used to return the difference between the 
specific station's average trip duration and the overall average trip duration. 
*/

SELECT
    starttime,
    start_station_id,
    tripduration,
    (
        SELECT ROUND(AVG(tripduration),2)
        FROM bigquery-public-data.new_york_citibike.citibike_trips
        WHERE start_station_id = outer_trips.start_station_id
    ) AS avg_duration_for_station,
    ROUND(tripduration - (
        SELECT AVG(tripduration)
        FROM bigquery-public-data.new_york_citibike.citibike_trips
        WHERE start_station_id = outer_trips.start_station_id), 2) AS difference_from_avg
FROM bigquery-public-data.new_york_citibike.citibike_trips AS outer_trips
ORDER BY difference_from_avg DESC
LIMIT 25;

/* Compose a new query to filter the data to include only the trips from the five stations 
with the longest mean trip duration. 
The result of the entire query is a list of records from the main table—specifically 
the tripduration and start_station_id for each record, but only those for records 
where the start_station_id is among the five stations with the greatest average trip 
durations. If you examine the query results, you will discover that only five of the
 start_station_id values are listed in column two.
*/

SELECT
    tripduration,
    start_station_id
FROM bigquery-public-data.new_york_citibike.citibike_trips
WHERE start_station_id IN
    (
        SELECT
            start_station_id
        FROM
        (
            SELECT
                start_station_id,
                AVG(tripduration) AS avg_duration
            FROM bigquery-public-data.new_york_citibike.citibike_trips
            GROUP BY start_station_id
        ) AS top_five
        ORDER BY avg_duration DESC
        LIMIT 5
    );