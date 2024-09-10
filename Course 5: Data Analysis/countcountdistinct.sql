/*COUNT and COUNT DISTINCT will return numerical values found within a dataset, 
helping you answer questions like, “How many customers did this?” 
Or, “How many transactions were there this month?” 
Or, “How many dates are in this dataset?”

Here we count the number of distinct states that have orders
Column one is the state, column two is the number of state with
that name that have orders
*/

SELECT
    state,
	COUNT(DISTINCT warehouse.state) as num_states
FROM
	`data-analytics-435214.warehouse_orders.orders` AS orders
JOIN
    `data-analytics-435214.warehouse_orders.warehouse` warehouse ON orders.warehouse_id = warehouse.warehouse_id
GROUP BY   
    warehouse.state
/*

*/