use Northwnd

---Retrieve all suppliers from the 'USA' whose city starts with 'N' or has 'o' in the second letter.	2 rows
SELECT * FROM supplier
WHERE country = 'USA' AND (city like 'N%' or city like '_o%')


---Find suppliers whose company name contains 'Liquids' or has 'o' in the third letter.					2 rows
SELECT * FROM supplier
WHERE company_name like '%Liquids%' or company_name like '__o%'


---3)	write a code to extract customerid, address and phone  where the phone number has open and close brackets and the address starts with C/	3 rows

SELECT
	customer_id, [address], phone
FROM customers
WHERE phone like '%(%)%' and address like 'C/%'




---4)	Retrieve suppliers whose contact name ends with 'i' or has 'a' in the third letter of their company name. 0 row

SELECT *
	
FROM supplier
WHERE contact_name like '%i' or company_name like '__a%'



---5)	5 Find suppliers whose city starts with 'M'or has 'Land' in their company name. 5 rows

SELECT *
FROM supplier
WHERE city like 'M%' or company_name like '%land%'


---6)	Find suppliers whose company name contains 'Ltd' and the contact name contains 'a'. 2 rows

SELECT *
FROM supplier
WHERE company_name like '%ltd%' and contact_name like '%a%'



---7)	Find suppliers with NULL fax numbers and whose company name contains 'Delights'. 1 row

SELECT *
FROM supplier
WHERE fax is null and company_name like '%Delights%'



---8)	Get suppliers with NOT NULL postal codes and whose city contains 'er'.	3 rows

SELECT *
FROM supplier
WHERE postal_code is not null and city like '%er%'



---9)	Get suppliers with NOT NULL phone numbers and whose city starts with 'A'.	2 rows

SELECT *
FROM supplier
WHERE phone is not null and city like 'A%'



---10.	Retrieve suppliers with NULL homepage and whose company name contains 'GmbH'.	1 row

SELECT *
FROM supplier
WHERE homepage is null and company_name like '%GmbH%'

---11)	Extract Companyname and phone number for all customers whose phone numbers has open and close brackets	56 rows

SELECT
	company_name, phone
FROM customers
WHERE phone LIKE '%(%%)%'


---12)	Here's the SQL code to extract customer details where the phone number has more than one dot or the address starts with 'Av':	19 rows

SELECT *
FROM customers
WHERE phone LIKE '%.%.%' OR address like 'Av%'

--PART 2
---1)	For all Orders shipped from USA and shipvia is 1, extract all CustomerID, RequiredDate,ShippedDate,ShipCountry,Freight, and ShipVia from orders for orders where Freight is 100 or more		10 rows

ALTER TABLE orders
alter column freight DECIMAL(10,2) NOT NULL

SELECT 
	customer_id, required_date, shipped_date, ship_country, freight, ship_via
FROM orders
WHERE ship_country = 'USA' AND ship_via = 1 and freight >= 100


---2)	Extract all rows for all orders where the orderdate is after 1996 and Shipvia is not 1, and the freight is between 50 and 100.		100 rows

SELECT *
FROM orders
WHERE order_date > '1996-12-31' and ship_via > 1 and (freight between 50 and 100)



---3)	How many orders shipped from USA from an address that starts with 187 were shipped before 1997?		1 row

SELECT *
FROM orders
WHERE ship_country like 'USA' AND ship_address like '187%' and shipped_date <= '1997-01-01'



---4)	How many orders shipped or ordered in 1997, excluding orders shipped from USA, Portugal or Ireland were not shipped via 3?		413

SELECT 
	count(order_id) No_of_orders
FROM orders
WHERE year(shipped_date) in (1997) or year(order_date) in (1997) and ship_country not IN ('USA', 'PORTUGAL', 'IRELAND') AND ship_via not in (3)



---5)	How many products are sold in bottles (use products table)

SELECT
	count(quantity_per_unit) Products_Sold_in_Bottles
FROM products
WHERE quantity_per_unit like '%bottle%'

use Northwnd

---Part Three

---1)	Question: Retrieve the top 5 customers who have made the most orders. Include customer details and order counts.

---Using Subquery
SELECT TOP 5 * FROM
(SELECT c.customer_id, c.company_name, c.contact_name, c.contact_title, 
		c.address, c.city, c.region, c.postal_code, c.country, c.phone, 
		c.fax, count(o.order_id) as Order_counts
FROM customers c
JOIN orders o on o.customer_id = c.customer_id
GROUP BY c.customer_id, c.company_name, c.contact_name, c.contact_title, 
		c.address, c.city, c.region, c.postal_code, c.country, c.phone, 
		c.fax) AS Customers_Order_details
ORDER BY Order_counts desc


---Using CTE
With Customers_Order_details as
(SELECT c.customer_id, c.company_name, c.contact_name, c.contact_title, 
		c.address, c.city, c.region, c.postal_code, c.country, c.phone, 
		c.fax, count(o.order_id) as Order_counts
FROM customers c
JOIN orders o on o.customer_id = c.customer_id
GROUP BY c.customer_id, c.company_name, c.contact_name, c.contact_title, 
		c.address, c.city, c.region, c.postal_code, c.country, c.phone, 
		c.fax)
SELECT TOP 5 * FROM Customers_Order_details
ORDER BY Order_counts desc



---2)	Question: List the employees who have placed the most orders. Include employee details and order counts.	9 rows

SELECT
		e.employee_id, e.last_name, e.first_name, e.title, count(o.order_id) as order_counts, e.title_of_courtesy, 
		e.birth_date, e.hire_date, e.[address], e.city, e.region, e.postal_code, 
		e.country, e.home_phone, e.extension, e.photo, e.notes, e.reports_to, e.photo_path
FROM employees e
		JOIN orders o on o.employee_id = e.employee_id
GROUP BY e.employee_id, e.last_name, e.first_name, e.title, e.title_of_courtesy, 
		e.birth_date, e.hire_date, e.[address], e.city, e.region, e.postal_code, 
		e.country, e.home_phone, e.extension, e.photo, e.notes, e.reports_to, e.photo_path
ORDER BY order_counts desc


---3)	Question: Retrieve all products and calculate the average price for each category. Show the category name, product name, and average price.

SELECT
	c.category_name, p.product_name, avg(p.unit_price) over (PARTITION BY c.category_id) as avg_price
FROM products p
JOIN categories c on c.category_id = p.category_id
group by category_name, p.product_name, c.category_id, p.unit_price

---4)	Question: List the top 3 customers who made the highest total purchases. Show customer details and total purchase amount.
use Northwnd
SELECT TOP 3 * FROM
(SELECT
	c.customer_id, c.company_name, c.contact_title, c.address, c.city, c.phone, 
	SUM(od.unit_price * od.quantity) as Total_Purchase_Amount
FROM customers c
JOIN orders o on o.customer_id = c.customer_id
JOIN order_details od on od.order_id = o.order_id
GROUP BY c.customer_id, c.company_name, c.contact_title, c.company_name, c.address, c.city, c.phone
) AS Top_customers
ORDER BY Total_Purchase_Amount desc


---5)	Calculate the rank of each product by price within its category. Show the product name, price, category, and rank.

SELECT
	p.product_name, p.unit_price, c.category_name,
	DENSE_RANK() over (partition by c.category_id order by p.unit_price DESC) as Price_ranking
FROM products p
JOIN categories c on c.category_id = p.category_id

SELECT
	p.product_name, p.unit_price, c.category_name,
	RANK() over (partition by c.category_id order by p.unit_price DESC) as Price_ranking
FROM products p
JOIN categories c on c.category_id = p.category_id


---6)	List the employees and their orders in descending order of the number of orders placed.

SELECT
	e.employee_id, e.first_name, e.last_name, count(od.order_id) as Orders_Placed
FROM employees e
JOIN orders o on o.employee_id = e.employee_id
JOIN order_details od on od.order_id = o.order_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY Orders_Placed desc



---7)	Retrieve the product names and the number of orders they appear in. Show the most ordered products first.

SELECT
	p.product_name, count(o.order_id) No_of_Orders
FROM products p
JOIN order_details od on od.product_id = p.product_id
JOIN orders o on o.order_id = od.order_id
GROUP BY p.product_name
ORDER BY No_of_Orders DESC


---8)	Calculate the dense rank of products by price within their category. Show product name, price, category, and dense rank.

SELECT
	p.product_name, p.unit_price, c.category_name,
DENSE_RANK () OVER (PARTITION BY c.category_id ORDER BY p.unit_price desc) as Price_ranking
FROM products p
JOIN categories c on c.category_id = p.category_id

---9)	Calculate the row number for products within their category, ordered by price. Show product name, price, category, and row number.

SELECT
	p.product_name, p.unit_price, c.category_name,
Row_Number () OVER (PARTITION BY c.category_id ORDER BY p.unit_price desc) as Row_Num
FROM products p
JOIN categories c on c.category_id = p.category_id



---10)	Create a stored procedure named GetOrderDetails that takes an OrderID as input and returns the details of that order.


CREATE PROCEDURE GetOrderDetails
	@OrderID INT
AS
BEGIN
	SELECT
		o.order_id, o.customer_id, o.employee_id, o.order_date, o.required_date, o.shipped_date, o.ship_via, 
		o.freight, o.ship_address, o.ship_city, o.ship_region, o.ship_postal_code, o.ship_country, 
		P.product_id, p.product_name, o.ship_name, od.product_id, od.quantity, od.unit_price, od.discount, 
		(od.unit_price * od.quantity) as Purchase_Price

FROM Orders o
JOIN order_details od on od.order_id = o.order_id
JOIN products p on p.product_id = od.product_id
WHERE O.order_id = @OrderID
END

EXEC GetOrderDetails @OrderID = 10250

---11)	Create a stored procedure named GetEmployeeOrders that takes an EmployeeID as input and returns all orders placed by that employee.

CREATE PROCEDURE GetEmployeeOrders
	@EmployeeID INT
AS
BEGIN
SELECT
		o.order_id, o.customer_id,o.order_date, o.required_date, o.shipped_date, o.ship_via, 
		o.freight, o.ship_address, o.ship_city, o.ship_region, o.ship_postal_code, o.ship_country, 
		od.quantity, od.unit_price, (od.quantity * od.unit_price) Total_Purchase_Price, od.discount, e.first_name, e.last_name

FROM orders o
JOIN order_details od on od.order_id = o.order_id
JOIN employees e on e.employee_id = o.employee_id
WHERE o.employee_id = @EmployeeID
END

exec GetEmployeeOrders @EmployeeID = 5

---12)	Create a stored procedure named GetHighValueCustomers that returns a list of customers who have made purchases above a specified total purchase amount.

CREATE PROCEDURE GetHighValueCustomers
	@Min_Total_Purchase_Amt decimal (10,2)
AS
BEGIN
SELECT 
		c.customer_id, c.company_name, c.contact_name, c.contact_title, c.address, 
		c.city, c.country, c.phone, SUM(od.quantity * od.unit_price) Total_Purchase_Amount
FROM	customers c
JOIN	orders o on o.customer_id = c.customer_id
JOIN	order_details od on od.order_id = o.order_id
GROUP BY c.customer_id, c.company_name, c.contact_name, c.contact_title, 
		 c.address, c.city, c.country, c.phone
HAVING SUM(od.quantity * od.unit_price) > @Min_Total_Purchase_Amt
END

exec GetHighValueCustomers @Min_Total_Purchase_Amt = 100000

---13)	Create a stored procedure named GetCategoryRevenue that takes a CategoryID as input and returns the total revenue for all products in that category.

CREATE PROCEDURE GetCategoryRevenue
	@CategoryID INT
AS
BEGIN
SELECT
	c.category_id, c.category_name, c.description, SUM(od.unit_price * od.quantity) AS Total_revenue
FROM categories c
JOIN products p on p.category_id = c.category_id
JOIN order_details od on od.product_id = p.product_id
WHERE c.category_id = @CategoryID
GROUP BY c.category_name, c.category_id, c.description
END

EXEC GetCategoryRevenue @CategoryID = 3

---14)	Create a stored procedure named GetProductSales that takes a ProductID as input and returns the total sales (revenue) for that product.

CREATE PROCEDURE GetProductSales
	@ProductID INT
AS
BEGIN
SELECT
	p.product_id, p.category_id, p.product_name, SUM(od.unit_price * od.quantity) AS Total_Sales
FROM
products p
JOIN order_details od on od.product_id = p.product_id
WHERE p.product_id = @ProductID
GROUP BY p.product_id, p.category_id, p.product_name
END

EXEC GetProductSales @ProductID = 10