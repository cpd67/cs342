-- This command file loads an experimental person database.
-- The data conforms to the following assumptions:
--     * People can have 0 or many team assignments.
--     * People can have 0 or many visit dates.
--     * Teams and visits don't affect one another.
--
-- CS 342, Spring, 2017
-- kvlinden
-- Edited by Chris Dilley (cpd5)

-- Exercise 4.2.a:

-- BCNF:
-- Superkeys for the PersonTeam relation:
	-- {personName, teamName}
-- Superkeys for the PersonVisit relation:
	-- {personName, personVisit}
-- FDs for PersonTeam:
	-- personName -> personName (trivial)
	-- personTeam -> personTeam (trivial)
-- FDs for PersonVisit:
	-- personName -> personVisit

-- Because no superkeys appear on the left-hand side of the functional dependencies, these relations are not in BCNF.

-- 4NF:
-- By the definition of 4NF, whereby it includes that every relation in 4NF is also in BCNF, because these relations are not in BCNF,
-- it follows that these relations are also not in 4NF.

-- Exercise 4.2.b:

-- This is the view:
-- PERSONNAME TEAMNAME   PERSONVIS
-- ---------- ---------- ---------
-- Shamkant   executive  22-FEB-15
-- Shamkant   elders     22-FEB-15
-- Shamkant   executive  01-MAR-15
-- Shamkant   elders     01-MAR-15

-- BCNF:
-- Superkeys:
	-- {personName, teamName}

-- FDs:
	-- {personName, teamName} -> personVisit

-- Because the superkeys show up on the left-hand side, it is in BCNF.

-- 4NF:
-- Because you have teams and visits independent of each other (where one does not affect the other), 
-- you have a multivalued dependency. Every time you add a Person to a team, you would also have to add a visit date every time that person visited the team.
-- As a result, you have teamName ->-> personName and teamName ->-> personVisit.
-- Because these two multivalued dependencies are trivial (if you know the team name then it should be straightforward that you know the person on the team and their visit date),
-- it satisifies the definition of 4NF and is therefore in 4NF.

-- Exercise 4.2.c:

-- No, they are not equally appropriate. The reason is because one of them is not in BCNF and/or 4NF while the other is. The latter schema is better as it in is BCNF and 4NF, 
-- therefore making anomalies with that schema less likely than if you were to use the other schema.
-- It does depend on context, as you may have different views of the data and so some schemata may be better than others because of the data that they show. 

DROP TABLE PersonTeam;
DROP TABLE PersonVisit;

CREATE TABLE PersonTeam (
	personName varchar(10),
    teamName varchar(10)
	);

CREATE TABLE PersonVisit (
	personName varchar(10),
    personVisit date
	);

-- Load records for two team memberships and two visits for Shamkant.
INSERT INTO PersonTeam VALUES ('Shamkant', 'elders');
INSERT INTO PersonTeam VALUES ('Shamkant', 'executive');
INSERT INTO PersonVisit VALUES ('Shamkant', '22-FEB-2015');
INSERT INTO PersonVisit VALUES ('Shamkant', '1-MAR-2015');

-- Query a combined "view" of the data of the form View(name, team, visit).
SELECT pt.personName, pt.teamName, pv.personVisit
FROM PersonTeam pt, PersonVisit pv
WHERE pt.personName = pv.personName;
