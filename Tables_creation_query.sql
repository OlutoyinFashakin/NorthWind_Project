CREATE DATABASE Northwnd

USE Northwnd

select * from categories
CREATE TABLE categories (
	category_id			INT					NOT NULL,
	category_name		NVARCHAR(50)		NULL,
	[description]		NVARCHAR(100)		NULL,
	picture				VARBINARY(max),
	PRIMARY KEY			(category_id)
);
GO



CREATE TABLE supplier (
	supplier_id			INT IDENTITY(1,1)	not null,
	company_name		nvarchar(50)		null,
	contact_name		varchar(100)		null,
	contact_title		varchar(50)			null,
	[address]			nvarchar(100)		null,
	city				varchar(50)			null,
	region				varchar(50)			null,
	postal_code			nvarchar(50)		null,
	country				varchar(20)			null,
	phone				char(20)			null,
	fax					char(20)			null,
	homepage			nvarchar(50)		null,
	PRIMARY KEY			(supplier_id)
);
GO



CREATE TABLE products (
	product_id			INT					not null,
	product_name		nvarchar(50)		null,
	supplier_id			INT					not null,
	category_id			INT					not null,
	quantity_per_unit	nvarchar(50)		null,
	unit_price			DECIMAL(10,2)		null,
	units_in_stock		INT					null,
	units_on_order		INT					null,
	reorder_level		INT					null,
	discontinued		INT					null,
	FOREIGN KEY (supplier_id)	REFERENCES supplier   (supplier_id)  ON DELETE CASCADE,
    FOREIGN KEY (category_id)	REFERENCES categories (category_id) ON DELETE CASCADE,
	PRIMARY KEY			(product_id)
);
GO


select * from employees
CREATE TABLE employees (
	employee_id			INT					not null,
	last_name			NVARCHAR(50)		not null,
	first_name			NVARCHAR(50)		not null,
	title				VARCHAR(50)			null,
	title_of_courtesy	VARCHAR(5)			null,
	birth_date			date				not null,
	hire_date			date				not null,
	[address]			NVARCHAR(100)		not null,
	city				NVARCHAR(50)		not null,
	region				VARCHAR(50)			not null,
	postal_code			NVARCHAR(50)		not null,
	country				VARCHAR(20)			not null,
	home_phone			CHAR(20)			null,
	extension			CHAR(20)			null,
	photo				VARBINARY(max),
	notes				NVARCHAR(max)		null,
	reports_to			CHAR(100)			null,
	photo_path			NVARCHAR(max)		null,
	PRIMARY KEY			(employee_id)
);
GO




CREATE TABLE customers (
	customer_id			NVARCHAR(6)			not null,
	company_name		NVARCHAR(50)		null,
	contact_name		NVARCHAR(100)		null,
	contact_title		NVARCHAR(50)		null,
	[address]			NVARCHAR(100)		null,
	city				VARCHAR(50)			null,
	region				VARCHAR(50)			null,
	postal_code			VARCHAR(50)			null,
	country				VARCHAR(20)			null,
	phone				CHAR(20)			null,
	fax					CHAR(20)			null,
	PRIMARY KEY			(customer_id)
);
GO


ALTER TABLE orders
ALTER COLUMN shipped_date date null

CREATE TABLE orders (
	order_id			INT					not null,
	customer_id			NVARCHAR(6)			not null,
	employee_id			INT					not null,
	order_date			DATE				not null,
	required_date		DATE				not null,
	shipped_date		DATE				not null,
	ship_via			NVARCHAR(50)		not null,
	freight				DECIMAL(10,2)		NOT NULL,
	ship_name			NVARCHAR(50)		not null,
	ship_address		NVARCHAR(100)		not null,
	ship_city			NVARCHAR(50)		not null,
	ship_region			NVARCHAR(50)		not null,
	ship_postal_code	CHAR(20)			not null,
	ship_country		NVARCHAR(50)		not null,
	FOREIGN KEY (customer_id)	REFERENCES customers   (customer_id)  ON DELETE CASCADE,
	FOREIGN KEY (employee_id)	REFERENCES employees	(employee_id)	ON DELETE CASCADE,
	PRIMARY KEY			(order_id)
);
GO



CREATE TABLE order_details (
	order_id			INT					not null,
	product_id			INT					not null,
	unit_price			DECIMAL(10,2)		not null,
	quantity			INT					null,
	discount			DECIMAL(10,2)		null,
	PRIMARY KEY			(order_id, product_id)
);
GO

ALTER TABLE order_details
---ALTER COLUMN unit_price DECIMAL(10,2)
---ALTER COLUMN quantity INT
ALTER COLUMN discount DECIMAL(10,2)





CREATE TABLE customer_demographics (
	customer_type_id		char(10)			not null,
	customer_desc			NVARCHAR(20)		null,
	PRIMARY KEY				(customer_type_id)
);
GO



CREATE TABLE customer_customer_demo (
	customer_id				NVARCHAR(6)			not null,
	customer_type_id		char(10)			not null,
	primary key (customer_id, customer_type_id)
);
GO


CREATE TABLE shippers (
	shipper_id				INT	IDENTITY(1,1)	not null,
	company_name			NVARCHAR(50)		not null,
	phone					CHAR(20)			null,
	PRIMARY KEY				(shipper_id)
);
GO



CREATE TABLE region (
	region_id					INT					not null,
	region_description			varchar(100)		null,
	PRIMARY KEY					(region_id)
);
GO

ALTER TABLE region
ALTER COLUMN region_description varchar(100)




CREATE TABLE territories (
	territory_id				INT					not null,
	territory_description		NVARCHAR(50)		null,
	region_id					INT					not null
	FOREIGN KEY (region_id)		REFERENCES region   (region_id)  ON DELETE CASCADE,
	PRIMARY KEY					(territory_id)
);
GO



CREATE TABLE employee_territories (
	employee_id					INT					not null,
	territory_id				INT					not null,
	PRIMARY KEY		(employee_id, territory_id)
);
GO




CREATE TABLE us_states (
	state_id					INT	IDENTITY(1,1)	not null,
	state_name					NVARCHAR(50)		not null,
	state_abbr					NVARCHAR(10)		null,
	state_region				NVARCHAR(50)		null,
	PRIMARY KEY					(state_id)
);
GO


ALTER TABLE categories
ALTER COLUMN description nvarchar(100)
