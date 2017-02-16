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

-- Schema implementation
CREATE TABLE CUSTOMER (
	customerID integer,
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
	-- orders made by that customer. 
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
	-- should also delete any records that require that order number. 
	FOREIGN KEY(orderNumber) REFERENCES ORDER(orderID) ON DELETE CASCADE,
	-- If you don't know the warehouse, you don't know where to ship the order to and so 
	-- shouldn't have records that have references to that warehouse that doesn't exist anymore. 
	FOREIGN KEY(warehouseNumber) REFERENCES WAREHOUSE(warehouseID) ON DELETE CASCADE
	);


-- Exercise 5.20.a

-- Exercise 5.20.c

