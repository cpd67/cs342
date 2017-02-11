-- CS-342 Lab02 2.1.
-- Chris Dilley (cpd5).
-- Date: 02/10/17.
-- Help in understanding referenced record vs. referencing record found here: https://en.wikipedia.org/wiki/Foreign_key

-- A: 

--i. 
-- What happens is an error occurs, saying that we violated a unique constraint.
-- Here's the error:
-- INSERT INTO Movie VALUES (1, 'The Movie Title', 1988, 1.1)
-- *
-- ERROR at line 1:
-- ORA-00001: unique constraint (CPD5.SYS_C006999) violated
-- The reason is because there is a unique constraint which disallows for repeated primary keys. 
-- Primary keys should be unique, as they identify unique records in a table. 
-- Having two primary keys that are the same would violate this constraint. 
INSERT INTO Movie VALUES (1, 'The Movie Title', 1988, 1.1, 1400);

-- ii. 
-- What happens is an error occurs, saying that we cannot insert that record into the table.
-- Here's the error: 
-- INSERT INTO Movie VALUES (NULL, 'The Movie Title 2: Back In Action', 1989, 1.0)
--                           *
-- ERROR at line 1:
-- ORA-01400: cannot insert NULL into ("CPD5"."MOVIE"."ID")
-- The reason is because there is an integrity constraint which disallows for NULL primary key values.
-- NULL means that the value is unknown, and it a primary key value MUST be known as it 
-- identifies a unique record in a table.
-- Having a NULL primary key would violate this constraint. 
INSERT INTO Movie VALUES (NULL, 'The Movie Title 2: Back In Action', 1989, 1.0, 1200);

-- iii. 
-- What happens is an error occurs saying that we violated a check constraint. 
-- Here's the error:
-- INSERT INTO Movie VALUES (3, 'The Movie Title 3: When Will It End', 1800, 1.0)
-- *
-- ERROR at line 1:
-- ORA-02290: check constraint (CPD5.SYS_C006998) violated
-- The reason is because there is an explicit check constraint defined in the Movie table
-- which checks if the year is less than a specified value (1900 in this case).
INSERT INTO Movie VALUES (3, 'The Movie Title 3: When Will It End?', 1800, 1.3, 1000);

-- iv. 
-- What happens is an error occurs saying we violated a unique constraint (type constraint).
-- Here's the error:
-- INSERT INTO Performer VALUES (1, 4)
-- *
-- ERROR at line 1:
-- ORA-00001: unique constraint (CPD5.SYS_C007000) violated
-- The reason is because there is a unique constraint which disallows for the violation of a data element type.
-- The type of value should match the type of the values in the domain. 
-- Having conflicting types would violate this constraint.
INSERT INTO Performer VALUES (1, 4);

-- v.
-- It works. The reason is because there is no constraint placed on the range of values that could be a score, 
-- which means that even negative scores are allowed as valid scores. 
INSERT INTO Movie VALUES (3, 'The Movie Title 4: Not Anytime Soon', 1990, -1.0, 900);

-- B:

-- i.
-- INSERT INTO Casting VALUES (NULL, 1, 'star')
-- It works. The reason is because there is no constraint on the foreign key values which disallows NULL values.
-- (e.g. NOT NULL).
INSERT INTO Casting VALUES (NULL, 1, 'star');

-- ii. 
-- What happens is an error occurs saying we violated an integrity constraint. 
-- INSERT INTO Casting VALUES (3, 2, 'star')
-- *
-- ERROR at line 1:
-- ORA-02291: integrity constraint (SYSTEM.SYS_C007009) violated - parent key not
-- found
-- The reason is because there is no primary key inside of the Movie table with ID = 4. 
-- Since a foreign key value has to refer to a Movie with an id, this violates the integrity constraint.
INSERT INTO Casting VALUES (4, 2, 'star');

-- iii.
-- It works. The reason is because there is no constraint enforced that forces a key in a 
-- referenced table to be associated with a record in a referencing table. 
INSERT INTO Movie VALUES (4, 'The Movie Title Reboot', 2000, 2.0, 1500);

-- C:

-- i.
-- It works. The reason is because of the ON DELETE CASCADE part of the Casting table for the 
-- movieId foreign key. If the record that holds the foreign key that the child record is referencing is deleted,
-- then the child record should also be deleted (the deletion 'cascades' from the parent record).
-- The is why we can't find the child records in Casting that refer to the parent record with id=1. 
DELETE FROM Movie WHERE id=2;
SELECT * FROM Casting;

-- ii.
-- It works. The reason is because there isn't a key value inside of the parent table (referenced record)
-- which refers back to the child table (referencing record), only the other way around. 
-- Deleting a child record wouldn't cause a constraint to be violated. 
DELETE FROM Casting WHERE movieId=1;

-- iii.
-- What happens is an error occurs saying we violated an integrity constraint.
-- Here's the error:
-- UPDATE Movie SET id=7 WHERE id=3
-- *
-- ERROR at line 1:
-- ORA-02292: integrity constraint (CPD5.SYS_C007016) violated - child record
-- found
-- The reason is because there is a child record in the Casting table which refers to the 
-- parent record in the Movie table with id 3. Changing the id of the parent record means
-- that the foreign key that the child record has is no longer valid, which would violate the constraint.
SELECT * FROM Movie WHERE id=3;
UPDATE Movie SET id=7 WHERE id=3;
SELECT * FROM Movie WHERE id=7;
