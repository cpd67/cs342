-- This command file loads a simple movies database, dropping any existing tables
-- with the same names, rebuilding the schema and loading the data fresh.
--
-- CS 342, Spring, 2015
-- kvlinden
-- Edited by Chris Dilley (cpd5) for Homework 2. 

-- Exercise 2.3:

-- The following website was helpful in coming up with a solution: http://softwareengineering.stackexchange.com/questions/182094/how-should-i-represent-an-enumerated-type-in-a-relational-database
-- Yes, you can modify the movies database to support the enumerated status type using the relational model
-- itself rather than hard-coding the values in a CHECK constraint. You could create a Status table, where
-- each record in that table represents a status for a Casting record in a movie. 
-- The values for each record would be an ID and the name of the status. 
-- Then, each Casting record would have a foreign key reference to a record in the 
-- Status table. 
-- This takes away the CHECK constraint and hard-coding the values, as a Casting record
-- can only have a status that is a record in the Status table (which will be enforced through 
-- referential integrity).
-- The changes are shown below:

-- Drop current database
DROP TABLE Casting;
DROP TABLE Status;
DROP TABLE Movie;
DROP TABLE Performer;

-- Create database schema
CREATE TABLE Movie (
	id integer,
	title varchar(70) NOT NULL, 
	year decimal(4), 
	score float,
	votes integer,
	PRIMARY KEY (id),
	CHECK (year > 1900)
	);

-- New table for the statuses
CREATE TABLE Status (
	ID integer,
	statusName varchar(6),
	PRIMARY KEY (ID)
	);

CREATE TABLE Performer (
	id integer,
	name varchar(35),
	PRIMARY KEY (id)
	);

CREATE TABLE Casting (
	movieId integer,
	performerId integer,
	-- Casting now has a foreign key reference to a Status record
	statusID integer,
	FOREIGN KEY (movieId) REFERENCES Movie(Id) ON DELETE CASCADE,
	FOREIGN KEY (performerId) REFERENCES Performer(Id) ON DELETE SET NULL,
	-- If the status no longer remains, set the statusID for a child record to NULL.
	FOREIGN KEY (statusID) REFERENCES Status(ID) ON DELETE SET NULL
	);

-- Load sample data
INSERT INTO Movie VALUES (1,'Star Wars',1977,8.9, 2000);
INSERT INTO Movie VALUES (2,'Blade Runner',1982,8.6, 1500);

INSERT INTO Performer VALUES (1,'Harrison Ford');
INSERT INTO Performer VALUES (2,'Rutger Hauer');
INSERT INTO Performer VALUES (3,'The Mighty Chewbacca');
INSERT INTO Performer VALUES (4,'Rachael');

-- Insert some records into the Status table
INSERT INTO Status VALUES (1, 'star');
INSERT INTO Status VALUES (2, 'costar');
INSERT INTO Status VALUES (3, 'extra');

-- Change the Casting records to reflect the foreign key reference to a Status record
INSERT INTO Casting VALUES (1,1,1);
INSERT INTO Casting VALUES (1,3,3);
INSERT INTO Casting VALUES (2,1,1);
INSERT INTO Casting VALUES (2,2,2);
INSERT INTO Casting VALUES (2,4,2);

-- The benefits are that you no longer have a hard-coded check constraint, 
-- so if you need to add new statuses, you only have to add a new record to the Status 
-- table (instead of going into the Casting table and changing the CHECK constraint itself).
-- Costs include having to do an extra join in order to find out the name of a status for a 
-- particular performer (between the Performer, Casting, and Status tables. You would have 
-- to check if the performerID and id for a Performer are the same, then the statusID and ID 
-- of the status, before you could get the correct statusName). (Before this, all you had 
-- to do was a join between the Performer and Casting tables to get the correct status name, 
-- since the status was inside of the Casting table.)