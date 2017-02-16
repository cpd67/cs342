-- Exercise 5.14:

-- The foreign keys are specified in the schema implementation below. They are: 
-- + customerNumber in the ORDER table, as that references a record in the CUSTOMER table with the associated customerNumber as its ID. 
-- + itemNumber in the ORDER_ITEM table, as that references a record in the ITEM table with the associated itemNumber as its ID.
-- + orderNumber in the SHIPMENT table,	as that references a record in the ORDER table with the associated orderNumber as its ID.
-- + warehouseNumber in the SHIPMENT table,	as that references a record in the WAREHOUSE table with the associated warehouseNumber as its ID.

-- Other constraints that I can think of for the database are implemented below as well. 
-- They include:
-- + checking the unitPrice field of a record in the ITEM table (we should not have items with negative prices)
-- + checking the orderAmount field of a record in the ORDER table (we should not have orders with negative amounts)
-- + checking the quantity field of a record in the ORDER_ITEM table (we should not have order items with negative quantities).

--First, drop any implemented tables before creating them.
DROP TABLE CUSTOMER;
DROP TABLE ORDER;
DROP TABLE ITEM;
DROP TABLE ORDER_ITEM;
DROP TABLE WAREHOUSE;
DROP TABLE SHIPMENT;

-- Schema implementation
CREATE TABLE CUSTOMER (
	customerID integer,
	-- Separate the first name and last name 
	-- into distinctive 
	customerFirstName varchar(50),
	customerLastName varchar(50),
	city varchar(20),
	PRIMARY KEY(customerID)
	);
	
CREATE TABLE ORDER (
	orderID integer,
	orderDate date,
	customerNumber integer,
	orderAmount float,
	PRIMARY KEY(orderID),
	-- If a customer no longer exists in a database, delete all records that contain 
	-- orders made by that customer because that customer no longer exists in the database. 
	FOREIGN KEY(customerNumber) REFERENCES CUSTOMER(customerID) ON DELETE CASCADE,
	CHECK (orderAmount >= 0.0)
	);

CREATE TABLE ITEM (
	itemID integer,	
	unitPrice float,
	itemName varchar(40),
	PRIMARY KEY(itemID),
	CHECK (unitPrice >= 0.0)
	);

CREATE TABLE ORDER_ITEM (
	orderID integer, 
	itemNumber integer,
	quantity integer,
	PRIMARY KEY(orderID),
	-- If an item no longer exists in a database, set the ID to null
	-- because at that point a record in the ORDER_ITEM is no longer 
	-- storing a valid value which is an ID of a record in the ITEM table. 
	FOREIGN KEY(itemNumber) REFERENCES ITEM(itemID) ON DELETE SET NULL,
	CHECK (quantity >= 0)
	);

CREATE TABLE WAREHOUSE (
	warehouseID integer, 
	city varchar(20),
	PRIMARY KEY(warehouseID)
	);
	
CREATE TABLE SHIPMENT (
	shipmentID integer,
	orderNumber integer, 
	warehouseNumber integer, 
	shipDate date,
	PRIMARY KEY(shipmentID),
	-- If you do not know the order number for a shipment, you don't know what to ship and so 
	-- should also delete any records that require that order number because you do not know what exactly
	-- to ship, which could cause problems.
	FOREIGN KEY(orderNumber) REFERENCES ORDER(orderID) ON DELETE CASCADE,
	-- If you don't know the warehouse, you don't know where to ship the order to and so 
	-- shouldn't have records that have references to that warehouse that doesn't exist anymore
	-- because you wouldn't know exactly where to ship an order to.
	FOREIGN KEY(warehouseNumber) REFERENCES WAREHOUSE(warehouseID) ON DELETE CASCADE
	);

-- Create 3-5 sample records
-- CUSTOMER records
INSERT INTO CUSTOMER VALUES (1, "Billy", "Bob", "Grand Rapids");
INSERT INTO CUSTOMER VALUES (2, "Joe", "Haskins", "San Diego");
INSERT INTO CUSTOMER VALUES (3, "Greg", "Johnson", "Lebanon");

-- ORDER records
INSERT INTO ORDER VALUES (1, '2011-03-11', 1, 30.0);
INSERT INTO ORDER VALUES (2, '2012-01-21', 2, 50.0);
INSERT INTO ORDER VALUES (3, '2013-04-01', 3, 6.00);
INSERT INTO ORDER VALUES (4, '2012-06-11', 2, 100.0);
INSERT INTO ORDER VALUES (5, '2015-08-28', 1, 40.0);

-- ITEM records
INSERT INTO ITEM VALUES (1, 30.0, "Boots");
INSERT INTO ITEM VALUES (2, 50.0, "Puppy");
INSERT INTO ITEM VALUES (3, 6.00, "Band-aids");
INSERT INTO ITEM VALUES (4, 100.0, "Golden Eggs");
INSERT INTO ITEM VALUES (5, 40.0, "Hat");

-- ORDER_ITEM records
INSERT INTO ORDER_ITEM VALUES (1, 1, 3);
INSERT INTO ORDER_ITEM VALUES (2, 2, 1);
INSERT INTO ORDER_ITEM VALUES (3, 3, 10);
INSERT INTO ORDER_ITEM VALUES (4, 4, 100);
INSERT INTO ORDER_ITEM VALUES (5, 5, 1);

-- WAREHOUSE records
INSERT INTO WAREHOUSE VALUES (1, "Grand Rapids");
INSERT INTO WAREHOUSE VALUES (2, "San Diego");
INSERT INTO WAREHOUSE VALUES (3, "Lebanon");

-- SHIPMENT records
INSERT INTO SHIPMENT VALUES (1, 1, 1, '2011-03-09');
INSERT INTO SHIPMENT VALUES (2, 2, 2, '2012-01-19');
INSERT INTO SHIPMENT VALUES (3, 3, 3, '2013-03-29');
INSERT INTO SHIPMENT VALUES (4, 4, 2, '2012-06-08');
INSERT INTO SHIPMENT VALUES (5, 5, 1, '2015-08-25');

-- Exercise 5.20.a

-- Exercise 5.20.c

