-- This command file loads a simple movies database, dropping any existing tables
-- with the same names, rebuilding the schema and loading the data fresh.
--
-- CS 342, Spring, 2015
-- kvlinden
-- Edited by Chris Dilley (cpd5) for Homework 2.

-- Exercise 2.4:

-- Drop current database
--DROP SEQUENCE movie_seq;
DROP TABLE Casting;
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

CREATE TABLE Performer (
	id integer,
	name varchar(35),
	PRIMARY KEY (id)
	);

CREATE TABLE Casting (
	movieId integer,
	performerId integer,
	status varchar(6),
	FOREIGN KEY (movieId) REFERENCES Movie(Id) ON DELETE CASCADE,
	FOREIGN KEY (performerId) REFERENCES Performer(Id) ON DELETE SET NULL,
	CHECK (status in ('star', 'costar', 'extra'))
	);

-- Create the sequence for the primary key values of the Movie relation.
CREATE SEQUENCE movie_seq
START WITH 1
INCREMENT BY 1 
NOCACHE
NOCYCLE;

-- Load sample data
-- Use the generated sequence numbers for the primary key values.
INSERT INTO Movie VALUES (movie_seq.nextval,'Star Wars',1977,8.9, 2000);
INSERT INTO Movie VALUES (movie_seq.nextval,'Blade Runner',1982,8.6, 1500);

INSERT INTO Performer VALUES (1,'Harrison Ford');
INSERT INTO Performer VALUES (2,'Rutger Hauer');
INSERT INTO Performer VALUES (3,'The Mighty Chewbacca');
INSERT INTO Performer VALUES (4,'Rachael');

INSERT INTO Casting VALUES (1,1,'star');
INSERT INTO Casting VALUES (1,3,'extra');
INSERT INTO Casting VALUES (2,1,'star');
INSERT INTO Casting VALUES (2,2,'costar');
INSERT INTO Casting VALUES (2,4,'costar');

-- Answers to questions:

-- 2.4.a: 
-- In order to maintain scalibility for this database, yes. If the database were 
-- to grow very large, it would be convienent to have another sequence also generate 
-- surrogate keys for the Performer records. That way, the Movie and Performer tables 
-- would both be able to grow very large (and you wouldn't have to keep track of 
-- the primary keys for both should you hard-code them yourself).

-- 2.4.b: 
-- To some degree, yes. If you forget to drop the sequence as well as the tables, 
-- then when you attempt to re-execute the command file, you will get errors as the 
-- sequence would not have been dropped. What happens then is that the nextval of the 
-- sequence would be the same nextval as when the command file was executed in the first place
-- (because it would not have been reset because you forgot to drop it when you 
-- dropped the tables). As a result, records in a table which got their primary keys 
-- from the sequence would not get the same key values; they would get different ones each time. 
-- This could cause problems if other records of other tables held foreign key references 
-- to those records that gained their keys from the sequence, because the foreign keys would not be 
-- valid anymore (as the parent records would have gotten different primary key values from the sequence). 
-- In sum, you MUST make sure that you drop the sequence when you drop the tables 
-- as this could cause problems with primary key assignment and foreign key references if the 
-- sequence hasn't been dropped. 