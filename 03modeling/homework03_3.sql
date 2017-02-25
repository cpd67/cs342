-- Homework 3: Exercise 9.11. 
-- Chris Dilley (cpd5).

drop table OrderPart;
drop table Part;
drop table Employee;
drop table Orders;
drop table Customer;

-- Customer table	
create table Customer (
	custID integer PRIMARY KEY,
	firstName varchar(30),
	lastName varchar(30),
	zip char(5)
	);

-- Orders table	
create table Orders (
	orderID integer PRIMARY KEY,
	receiptDate date, 
	expectDate date,
	actualDate date,
	custID integer,
	-- We don't want any order records from a deleted customer, 
	-- so delete all of them as well.
	FOREIGN KEY(custID) REFERENCES Customer(custID) ON DELETE CASCADE
	);
	
-- Employee table
create table Employee (
	empID integer PRIMARY KEY,
	firstName varchar(30),
	lastName varchar(30),
	zipCode char(5),
	orderTaken integer,
	-- We don't have to delete the Employee record if an order record 
	-- is deleted, so just set this foreign key to NULL.
	FOREIGN KEY(orderTaken) REFERENCES Orders(orderID) ON DELETE SET NULL
	);

-- Part table
create table Part (
	partID integer PRIMARY KEY,
	name varchar(30),
	price float,
	quantity integer
	);

-- This table keeps track of the quantity for each Part specified in an 
-- Order record.
create table OrderPart(
	ID integer PRIMARY KEY,
	orderNumber integer,
	partNumber integer,
	quantity integer,
	-- If we no longer have the Order record, delete all records in this table 
	-- with that Order record.
	FOREIGN KEY(orderNumber) REFERENCES Orders(orderID) ON DELETE CASCADE,
	-- If we don't have the Part record, set its ID to NULL as we still 
	-- have the Order record.
	FOREIGN KEY(partNumber) REFERENCES Part(partID) ON DELETE SET NULL
	);
	
-- Sample records
INSERT INTO Customer VALUES(0, 'Edward', 'Jones', '49505');
INSERT INTO Customer VALUES(1, 'Sam', 'Myonmar', '49404');

INSERT INTO Orders VALUES(0, DATE '2011-03-01',  DATE '2011-03-11', DATE '2011-03-12', 0);
INSERT INTO Orders VALUES(1, DATE '2011-04-02',  DATE '2011-04-12', DATE '2011-04-20', 1);

INSERT INTO Employee VALUES(0, 'Jared', 'Michaels', '49505', 0);
INSERT INTO Employee VALUES(1, 'Barry', 'Michaels', '49595', 1);

INSERT INTO Part VALUES(0, 'Hammer', '10.50', 100);
INSERT INTO Part VALUES(1, 'Pliers', '8.50', 300);

INSERT INTO OrderPart VALUES(0, 0, 0, 50);
INSERT INTO OrderPart VALUES(1, 1, 1, 100);
