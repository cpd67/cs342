-- Sample version of the Movies database for guide 5
--
-- CS 342, Spring, 2017
-- kvlinden
-- Edited by Chris Dilley (cpd5).
-- The guide questions and queries are found below.

-- Drop current database
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
	firstName varchar(20),
	lastName varchar(25),
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

-- Load sample data
INSERT INTO Movie VALUES (1,'Star Wars',1977,8.9, 2000);
INSERT INTO Movie VALUES (2,'Blade Runner',1982,8.6, 1500);

INSERT INTO Performer VALUES (1,'Harrison', 'Ford');
INSERT INTO Performer VALUES (2,'Rutger', 'Hauer');
INSERT INTO Performer VALUES (3,'Chewbacca', NULL);
INSERT INTO Performer VALUES (4,'Rachael', NULL);
INSERT INTO Performer VALUES (5,'Rex', 'Harrison');

INSERT INTO Casting VALUES (1,1,'star');
INSERT INTO Casting VALUES (1,3,'extra');
INSERT INTO Casting VALUES (2,1,'star');
INSERT INTO Casting VALUES (2,2,'costar');
INSERT INTO Casting VALUES (2,4,'costar');

-- 1. Basic SQL (Section 6.3) — Review basic SQL as needed, then write sample queries that:

-- a. Use one or more tuple variables (Section 6.3.2).
-- (Oracle only supports column aliasing, not table aliasing).

-- Use tuple variables for the firstName, lastName, and status columns of the Performer and Casting tables, respectively.
SELECT firstName AS fName, lastName AS lName, status AS stardom, id  
FROM Performer, Casting 
WHERE id < 3 AND id = performerId
ORDER BY fName;
 
-- b. Use one or more of the set operations, e.g., UNION, EXCEPT, INTERSECT (Section 6.3.4).

-- Make a list of movies that Harrison Ford was in, either where he was a star or an extra.
(SELECT DISTINCT title -- Star query
 FROM Movie, Performer, Casting
 WHERE Performer.lastName = 'Ford' AND Movie.id = Casting.movieId AND Casting.status = 'star')
UNION
(SELECT DISTINCT title  -- Extra query
 FROM Movie, Performer, Casting
 WHERE Performer.lastName = 'Ford' AND Movie.id = Casting.movieId AND Casting.status = 'extra');

-- 2. Advanced SQL (Sections 7.1.1–7.1.5) — This will include more new material; write sample queries that:

-- a. Select based on a NULL field value (Section 7.1.1).

-- Select the first name of performers who don't have last names.
SELECT firstName
FROM Performer
WHERE Performer.lastName IS NULL;

-- b. Implement a nested sub-query, using [NOT] EXISTS, IN, ANY or ALL (Sections 7.1.2–7.1.4).

-- Select the performers who were costars in their movies.
SELECT firstName, lastName
FROM Performer, Casting
WHERE Performer.id = Casting.performerId AND Casting.status IN (SELECT status FROM Casting WHERE status='costar');

-- c. Implement a correlated sub-query (Section 7.1.3).

-- Retrieve the names of movies who have no costars and that have more than 1000 votes
SELECT title
FROM Movie
WHERE NOT EXISTS ( SELECT * FROM Casting WHERE id = Casting.movieId AND status = 'costar' AND votes > 1000); 
 
