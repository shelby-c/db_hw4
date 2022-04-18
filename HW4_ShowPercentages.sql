-- ShowPercentages.sql
/*
Given a single SID identifier, display a single student’s percentage (not raw) scores for 
each assignment given in the HW4 Assignment table, and a single weighted course average (a percentage). 
For a specified student, all 3 tests have equivalent weight in the creation of a test average, 
and all 4 quizzes have equivalent weight in the creation of a quiz average. 
Then, the overall course average calculation weights the test average as 60% of the grade, 
and the quiz average as 40% of the grade. If a student has not attempted a specific quiz or test, 
then for the purposes of average calculations, it is as if they earned a 0 on that assessment. 
All of the values output in the table should be output with exactly 2 decimal places. 
The order of display of the information in the PHP-generated table should be: SID, lname, fname, section, 
then the percentages for each assignment name in the course (as given in the HW4 Assignment table), 
and finally courseAvg. Use meaningful column headers. The quiz average and test average need not 
be displayed in the output. If the given SID does not exist in the database, the PHP script should not 
display any table, but should instead display a descriptive message of the form ”ERROR: SID XXXX not found”, 
where XXXX is replaced by the given SID. 
Use the filenames HW4 ShowPercentages.sql and HW4 ShowPercentages.php for this item.
*/

DELIMITER //

-- Get grades as a percentage for each assignment
-- NEED TO ACCOUNT FOR UNATTEMPTED ASSIGNMENTS
DROP VIEW IF EXISTS AssignmentPercentages;

CREATE VIEW AssignmentPercentages AS
SELECT HW4_RawScore.SID AS SID, HW4_Assignment.AName AS AName, (HW4_RawScore.Score / HW4_Assignment.PtsPoss) AS AssignmentPercent, HW4_Assignment.AType AS AType
FROM HW4_RawScore, HW4_Assignment
WHERE HW4_RawScore.AName = HW4_Assignment.AName;

-- Course avg to be calculated as (points earned) / (total points possible)
-- NEED TO ACCOUNT FOR UNATTEMPTED ASSIGNMENTS
DROP VIEW IF EXISTS CourseAverage;

CREATE VIEW CourseAverage AS
SELECT AssignmentPercentages.SID AS SID, (SUM(SELECT AssignmentPercentages.AssignmentPercent
                                              FROM AssignmentPercentages
                                              WHERE AssignmentPercentages.AType = 'QUIZ') * 0.4 + 
                                            SUM (SELECT AssignmentPercentages.AssignmentPercent
                                                 FROM AssignmentPercentages
                                                 WHERE AssignmentPercentages.AType = 'EXAM') * 0.6)  AS CourseAvg
FROM AssignmentPercentages
GROUP BY AssignmentPercentages.SID;


DROP PROCEDURE IF EXISTS HW4_ShowPercentages //

CREATE PROCEDURE HW4_ShowPercentages(IN sid VARCHAR(10))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Student WHERE SID = sid) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      SELECT HW4_Student.SID, HW4_Student.LName, HW4_Student.FName, HW4_Student.Sec, HW4_RawScore.AName, HW4_RawScore.Score
      FROM HW4_Student JOIN AssignmentPercentages
      ON HW4_Student.SID = AssignmentPercentages.SID
      WHERE HW4_Student.SID = sid;
   ELSE
       SELECT 'ERROR: SID ' + sid+ 'not found' AS SID;
   END IF;
END; //

DELIMITER ;