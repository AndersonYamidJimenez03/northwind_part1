-- How many customers are there per country?

SELECT country, count(*) Qty
FROM customers
GROUP BY country
ORDER BY Qty DESC;

-- What are the top 10 countries with the highest number of orders placed? Additionally, also relate the number of customers.

SELECT 
    c.country, 
    COUNT(DISTINCT c.CustomerId) AS Qty, COUNT(o.OrderID) AS Orders
FROM customers AS c
LEFT JOIN orders AS o 
ON c.CustomerId = o.CustomerId
GROUP BY c.country
ORDER BY Qty DESC, Orders DESC
LIMIT 10;


-- What is the average number of orders placed by employees (full name) and by each of the shippers?

SELECT 
    CONCAT(e.firstname, ' ', e.lastname) AS Name, 
    s.companyname AS ShipperName,
    ROUND(AVG(o.orderid), 0) AS avg_ordersByEmployee
FROM employees AS e
JOIN  orders AS o
ON e.EmployeeId = o.EmployeeId
JOIN shippers AS s
ON s.shipperId = o.shipperId
GROUP BY Name, ShipperName
ORDER BY Name, avg_ordersByEmployee DESC


-- What is the total sales amount (without discount) by country, region, and shipper company?


SELECT 
    CASE 
        WHEN o.shipcountry = 'USA' THEN 'United States of America'
        WHEN o.shipcountry = 'UK' THEN 'United Kingdom'
        ELSE o.shipcountry
    END AS valid_contry,
    COALESCE(o.shipregion, 'No Region Info') valid_region,
    s.companyname deliver_company,
    SUM(od.unitprice * od.quantity)::money total
FROM orders AS o
JOIN orders_details od 
ON o.orderId = od.orderId
JOIN shippers s 
ON o.shipperId = s.shipperId
GROUP BY valid_contry, valid_region, deliver_company
ORDER BY valid_contry, valid_region, total DESC


-- What is the total freight value, its maximum value, and the average service time of the company (days between order date and shipping date) for each year and month?

SELECT
    EXTRACT(MONTH FROM orderdate) AS month_number,
    TO_CHAR(orderdate, 'Month') AS month_name,   
    SUM(freight)::money AS total_freight, 
    MAX(freight)::money AS max_freight,
    ROUND(AVG(Extract(DAY FROM AGE(shippeddate, orderdate))),0) AS avg_of_service_time 
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 1997
GROUP BY month_number, month_name
ORDER BY month_number

