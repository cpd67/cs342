-- Starter code for lab 3.
--
-- CS 342, Spring, 2017
-- kvlinden
-- Edited by Chris Dilley (cpd5) for Lab 3.
-- Date: 02/17/17 

-- Drop any previously created tables (in the order by which the foreign keys go)
-- (So, any Tables that do NOT have records which have foreign key references made by other records from 
--  other Tables, drop them first). 
drop table PersonTeam;
drop table Team;
drop table Person;
drop table Homegroup;
drop table Request;
drop table HouseHold;

-- Household table
create table HouseHold(
	ID integer PRIMARY KEY,
	street varchar(30),
	city varchar(30),
	state varchar(2),
	zipcode char(5),
	phoneNumber char(12)
	);

-- Exercise 3.3
create table Request (
	dateSubmitted date PRIMARY KEY, 
	text varchar(150),
	accessCode char(1),
	response varchar(150),
	householdNumber integer,
	-- In the event a HouseHold record is deleted, 
	-- delete all requests from that HouseHold.
	FOREIGN KEY(householdNumber) REFERENCES HouseHold(ID) ON DELETE CASCADE
	);
	
-- Homegroup table
create table Homegroup (
	ID integer PRIMARY KEY,
	name varchar(30),
	topic varchar(30)
	);

-- Person table
create table Person (
	ID integer PRIMARY KEY,
	title varchar(4),
	firstName varchar(15),
	lastName varchar(15),
	-- Since a Person can be a mentor, store the ID here.  
	mentorID integer,
	-- A Person should belong to a HouseHold, so this cannot be NULL.
	householdID integer NOT NULL,
	homegroupID integer,
	role varchar(30),	
	membershipStatus char(1) CHECK (membershipStatus IN ('m', 'a', 'c')),
	requestID date,
	-- Have a recursive reference to the ID of a Person record for the mentorID.
	FOREIGN KEY(mentorID) REFERENCES Person(ID) ON DELETE SET NULL,
	-- Due to the 1-many relationship between the Person and HouseHold tables, 
	-- if a HouseHold record is deleted, all Persons 'living' in that record should also be deleted
	-- since they cannot have NULL householdIDs. 
	FOREIGN KEY(householdID) REFERENCES HouseHold(ID) ON DELETE CASCADE,
	-- Since a Person record might not belong to a Homegroup, set this to NULL 
	-- if the Homegroup record that they belong to is deleted.
	FOREIGN KEY(homegroupID) REFERENCES Homegroup(ID) ON DELETE SET NULL, 
	-- Request IDs can be NULL, as a Request can be assigned to 0 or 1 Persons.
	FOREIGN KEY(requestID) REFERENCES Request(dateSubmitted) ON DELETE SET NULL,
	-- Check the foreign keys, making sure that they are not be negative.
	-- (The mentorID can be NULL, as a Person may not be a mentor to anyone or have a mentor themselves). 
	-- (The homegroupID can be NULL, as a Person may not belong to a Homegroup).
	CHECK (mentorID >= 0 OR mentorID IS NULL),
	CHECK (householdID >= 0), 
	CHECK (homegroupID >= 0 OR homegroupID IS NULL)
	);

-- Team table	
create table Team (
	ID integer PRIMARY KEY,
	name varchar(30), 
	mandate varchar(40) 
	);

-- PersonTeam table	
create table PersonTeam (
	personID integer, 
	teamID integer,
	role varchar(30),
	-- Have the time be stored as a start and end date.
	-- That way, you can figure out when a Person on a Team starts a role and when 
	-- the role should end.
	startDate date,
	endDate date,
	-- If the Person record no longer exists, it could mean that the role is available on the team
	-- and so another Person record could fill that role. Which is why you should set the personID 
	-- foreign key to null instead of deleting the record itself (for another person could fill the role). 
	FOREIGN KEY(personID) REFERENCES Person(ID) ON DELETE SET NULL,
	-- If the Team record no longer exists, delete the whole record as the role no longer exists for that particular team.
	FOREIGN KEY(teamID) REFERENCES Team(ID) ON DELETE CASCADE
	);

INSERT INTO Household VALUES (0,'2347 Oxford Dr. SE','Grand Rapids','MI','49506','616-243-5680');
-- New record
INSERT INTO Household VALUES (1,'1234 Candy Cane Dr.','Gumdrop City','CL','11111','123-456-0000');

INSERT INTO Homegroup VALUES (0, 'Bible Study #1', 'The Gospels');
INSERT INTO Homegroup VALUES (1, 'Bible Study #2', 'Minor Prophets');

-- New records	
INSERT INTO Request VALUES(DATE '2017-01-01', 'This house needs prayers.', 'a', 'I will pray for you.', 0);
INSERT INTO Request VALUES(DATE '2017-02-01', 'This house also needs prayers.', 'b', 'I will pray for you.', 1);

INSERT INTO Person VALUES (0,'mr.','Keith','VanderLinden',NULL,0,0,'husband','m', NULL);
INSERT INTO Person VALUES (1,'ms.','Brenda','VanderLinden',0,0,0,'wife','m', DATE '2017-02-01');
INSERT INTO Person VALUES (2,'mr.','James','Smith',0,0,1,'gardner', 'a', NULL);
INSERT INTO Person VALUES (3,'mrs.','Kendra','Jones',1,0,0,'maid','a', NULL);
-- New record
INSERT INTO Person VALUES (4,'mr.','Gingerbread','Man',NULL,1,0,'candyman','m',DATE '2017-01-01');

INSERT INTO Team VALUES (0, 'Music Team', 'To make music!');

INSERT INTO PersonTeam VALUES (0, 0, 'Leader', DATE '2017-01-21', DATE '2017-01-29');
INSERT INTO PersonTeam VALUES (2, 0, 'Guitarist', DATE '2017-01-22', DATE '2017-01-30');



