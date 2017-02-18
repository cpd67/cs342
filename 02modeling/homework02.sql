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
DROP TABLE ORDER_ITEM;
DROP TABLE ITEMS;
DROP TABLE SHIPMENT;
DROP TABLE ORDERS;
DROP TABLE WAREHOUSE;
DROP TABLE CUSTOMER;

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
	
CREATE TABLE ORDERS (
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

CREATE TABLE ITEMS (
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
	FOREIGN KEY(itemNumber) REFERENCES ITEMS(itemID) ON DELETE SET NULL,
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
	FOREIGN KEY(orderNumber) REFERENCES ORDERS(orderID) ON DELETE CASCADE,
	-- If you don't know the warehouse, you don't know where to ship the order to and so 
	-- shouldn't have records that have references to that warehouse that doesn't exist anymore
	-- because you wouldn't know exactly where to ship an order to.
	FOREIGN KEY(warehouseNumber) REFERENCES WAREHOUSE(warehouseID) ON DELETE CASCADE
	);

-- Create 3-5 sample records
-- CUSTOMER records
INSERT INTO CUSTOMER VALUES (1, 'Billy', 'Bob', 'Grand Rapids');
INSERT INTO CUSTOMER VALUES (2, 'Joe', 'Haskins', 'San Diego');
INSERT INTO CUSTOMER VALUES (3, 'Greg', 'Johnson', 'Lebanon');
INSERT INTO CUSTOMER VALUES (4, 'Harry', 'Osborn', 'Grand Haven');
INSERT INTO CUSTOMER VALUES (5, 'Jerry', 'Eaton', 'Ada');

-- ORDER records
INSERT INTO ORDERS VALUES (1, DATE '2011-03-11', 1, 30.0);
INSERT INTO ORDERS VALUES (2, DATE '2012-01-21', 2, 50.0);
INSERT INTO ORDERS VALUES (3, DATE '2013-04-01', 3, 6.00);
INSERT INTO ORDERS VALUES (4, DATE '2012-06-11', 2, 40.0);
INSERT INTO ORDERS VALUES (5, DATE '2015-08-28', 1, 40.0);

-- ITEM records
INSERT INTO ITEMS VALUES (1, 30.0, 'Boots');
INSERT INTO ITEMS VALUES (2, 50.0, 'Puppy');
INSERT INTO ITEMS VALUES (3, 6.00, 'Band-aids');
INSERT INTO ITEMS VALUES (4, 100.0, 'Golden Eggs');
INSERT INTO ITEMS VALUES (5, 40.0, 'Hat');

-- ORDER_ITEM records
INSERT INTO ORDER_ITEM VALUES (1, 1, 3);
INSERT INTO ORDER_ITEM VALUES (2, 2, 1);
INSERT INTO ORDER_ITEM VALUES (3, 3, 10);
INSERT INTO ORDER_ITEM VALUES (4, 5, 1);
INSERT INTO ORDER_ITEM VALUES (5, 5, 1);

-- WAREHOUSE records
INSERT INTO WAREHOUSE VALUES (1, 'Grand Rapids');
INSERT INTO WAREHOUSE VALUES (2, 'San Diego');
INSERT INTO WAREHOUSE VALUES (3, 'Lebanon');

-- SHIPMENT records
INSERT INTO SHIPMENT VALUES (1, 1, 1, DATE '2011-03-09');
INSERT INTO SHIPMENT VALUES (2, 2, 2, DATE '2012-01-19');
INSERT INTO SHIPMENT VALUES (3, 3, 3, DATE '2013-03-29');
INSERT INTO SHIPMENT VALUES (4, 4, 2, DATE '2012-06-08');
INSERT INTO SHIPMENT VALUES (5, 5, 1, DATE '2015-08-25');

-- Exercise 5.20.a

-- Exercise 5.20.c

-- 3.a.
SELECT orderDate, orderAmount FROM ORDERS, CUSTOMER 
	WHERE customerNumber=customerID AND (customerFirstName || ' ' || customerLastName)='Billy Bob' ORDER BY orderDate;

-- 3.b.
--Help in using the DISTINCT claus was obtained from:
--http://stackoverflow.com/questions/12239169/how-to-select-records-without-duplicate-on-just-one-field-in-sql
SELECT DISTINCT customerID FROM CUSTOMER, ORDERS WHERE customerID=customerNumber;
SELECT customerID FROM CUSTOMER;
SELECT customerNumber FROM ORDERS;

-- 3.c.
SELECT customerID, customerFirstName, customerLastName FROM CUSTOMER, ORDERS, ITEMS, ORDER_ITEM 
	WHERE (customerID=ORDERS.customerNumber) AND (ORDERS.orderID=ORDER_ITEM.orderID) AND (ORDER_ITEM.itemNumber=ITEMS.itemID) AND (ITEMS.itemName='Hat');

-- Lab Exercise 2.3

-- Lab Exercise 2.4