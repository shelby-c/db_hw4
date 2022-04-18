-- HW4_AllCourseAverages.sql
/*
If given any valid password present in the HW4 passwords table, display a full table of summary data 
for all students in the course (excluding the total points tuple) sorted first by section in ascending order, 
and then by course average in descending order, and finally in ascending order by last then first name. 
The information displayed in one row and the corresponding table headers displayed should be, 
in order: SID, LName, FName, section, courseAvg. Use the filenames HW4 ShowAllCourseAverages.sql and
HW4 ShowAllCourseAverages.php for this item.
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
SELECT AssignmentPercentages.SID AS SID, QuizPercentages * 0.4 + ExamPercentages * 0.6 AS CourseAvg
FROM (SELECT SUM(AssignmentPercentages.AssignmentPercent)
      FROM AssignmentPercentages
      WHERE AssignmentPercentages.AType = 'EXAM'
      GROUP BY AssignmentPercentages.SID) AS ExamPercentages, 
                                (SELECT SUM(AssignmentPercentages.AssignmentPercent)
                                FROM AssignmentPercentages
                                WHERE AssignmentPercentages.AType = 'QUIZ'
                                GROUP BY AssignmentPercentages.SID) AS QuizPercentages
WHERE ExamPercentages.SID = QuizPercentages.SID;

DROP PROCEDURE IF EXISTS HW4_AllCourseAverages //

CREATE PROCEDURE HW4_AllCourseAverages(IN Password VARCHAR(10))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Password WHERE HW4_Password.CurPasswords = Password) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      SELECT HW4_Student.SID, HW4_Student.LName, HW4_Student.FName, HW4_Student.Sec, CourseAverage.CourseAvg
      FROM HW4_Student JOIN CourseAverage
      ON HW4_Student.SID = CourseAverage.SID;
      ORDER BY HW4_Student.Sec ASC, CourseAverage.CourseAvg DESC, HW4_Student.LName ASC, HW4_Student.FName ASC;
   ELSE
       SELECT '(all course averages) ERROR: Invalid password' AS SID;
   END IF;
END; //

DELIMITER ;
