-- Starter code for lab 3.
--
-- CS 342, Spring, 2017
-- kvlinden

drop table Person;
drop table HouseHold;

create table HouseHold(
	ID integer PRIMARY KEY,
	street varchar(30),
	city varchar(30),
	state varchar(2),
	zipcode char(5),
	phoneNumber char(12)
	);

create table Person (
	ID integer PRIMARY KEY,
	title varchar(4),
	firstName varchar(15),
	lastName varchar(15),
	mentorID integer,
	householdID integer,
	role varchar(30),
	membershipStatus char(1) CHECK (membershipStatus IN ('m', 'a', 'c')),
	FOREIGN KEY(mentorID) REFERENCES Person(ID) ON DELETE SET NULL,
	FOREIGN KEY(householdID) REFERENCES HouseHold(ID) ON DELETE SET NULL,
	CHECK (mentorID >= 0 OR mentorID IS NULL)
	);
	
INSERT INTO Household VALUES (0,'2347 Oxford Dr. SE','Grand Rapids','MI','49506','616-243-5680');

INSERT INTO Person VALUES (0,'mr.','Keith','VanderLinden',NULL,0,'husband','m');
INSERT INTO Person VALUES (1,'ms.','Brenda','VanderLinden',0,0,'wife','m');
