-- This command file loads an experimental person relation.
-- The data conforms to the following assumptions:
--     * Person IDs and team names are unique for people and teams respectively.
--     * People can have at most one mentor.
--     * People can be on many teams, but only have one role per team.
--     * Teams meet at only one time.
--
-- CS 342
-- Spring, 2017
-- kvlinden

drop table AltPerson;

-- Exercise 4.1.a:

-- Informally, you have many attributes that should belong to different entities located inside
-- of the same relation. The team attributes should belong to a separate team relation, not to the 
-- AltPerson relation. To add, there are many field values which could be NULL, which may cause spurious 
-- tuples to appear when you attempt to do a natural join with this table. Also, there is a lot of redundant data
-- in this relation; in order to say that Shamkant is in two different teams, you would need to add two records 
-- with his information, which seems redundant as you are adding in his information multiple times when you should be
-- doing that once to avoid redundancy.
-- Formally, you will have to list out all of the superkeys of this relation and then determine the functional dependencies.
-- Afterwards, you must see if the left-hand side has all of the superkeys. If it doesn't, then the relation fails to adhere to 
-- the definition of BCNF.
-- You will find that this relation doesn't adhere to that definition, as seen below:
-- Superkeys:
	-- personId
	-- {personId, name}
	-- mentorId
	-- {mentorId, mentorName}
	-- All of the fields of the relation is also considered a superkey ({personId, name, ...}).
-- FDs:
	-- personId -> name, status, mentorId, mentorName, mentorStatus, teamName, teamRole, teamTime.
	-- {personId, name} -> mentorId, mentorName, mentorStatus.
	-- mentorId -> mentorName, mentorStatus.
	-- teamName -> teamTime.
-- We don't even have to list all of the functional dependencies in order to see that some of the superkeys do 
-- not show up. In particular, {mentorId, mentorName}.
-- Because of this, this relation is not in BCNF and is thus poorly designed.

-- Exercise 4.1.b:
-- A properly normalized schema for this database would be one that 
CREATE TABLE AltPerson (
	personId integer,
	name varchar(10),
	status char(1),
	mentorId integer,
	mentorName varchar(10),
	mentorStatus char(1),
    teamName varchar(10),
    teamRole varchar(10),
    teamTime varchar(10)
	);

INSERT INTO AltPerson VALUES (0, 'Ramez', 'v', 1, 'Shamkant', 'm', 'elders', 'trainee', 'Monday');
INSERT INTO AltPerson VALUES (1, 'Shamkant', 'm', NULL, NULL, NULL, 'elders', 'chair', 'Monday'); 
INSERT INTO AltPerson VALUES (1, 'Shamkant', 'm', NULL, NULL, NULL, 'executive', 'protem', 'Wednesday');
INSERT INTO AltPerson VALUES (2, 'Jennifer', 'v', 3, 'Jeff', 'm', 'deacons', 'treasurer', 'Tuesday');
INSERT INTO AltPerson VALUES (3, 'Jeff', 'm', NULL, NULL, NULL, 'deacons', 'chair', 'Tuesday');


