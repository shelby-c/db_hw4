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
DROP VIEW IF EXISTS Assignments;

CREATE VIEW Assignments AS
SELECT HW4_RawScore.SID AS SID, HW4_Assignment.AName AS AName, FORMAT(COALESCE(HW4_RawScore.Score, 0) / HW4_Assignment.PtsPoss * 100, 2) AS Score, HW4_Assignment.AType AS AType
FROM HW4_RawScore RIGHT OUTER JOIN HW4_Assignment
ON HW4_RawScore.AName = HW4_Assignment.AName;

-- Course avg to be calculated as (points earned) / (total points possible)
-- NEED TO ACCOUNT FOR UNATTEMPTED ASSIGNMENTS
DROP VIEW IF EXISTS CourseAverages; -- course avg for 1006 should be 78.3999

CREATE VIEW CourseAverages AS
SELECT ExamPercentages.SID AS SID, COALESCE(QuizAvg, 0) * 0.4 + COALESCE(ExamAvg, 0) * 0.6 AS CourseAvg
FROM (SELECT AVG(IFNULL(Assignments.Score, 0)) AS ExamAvg, Assignments.SID AS SID
      FROM Assignments
      WHERE Assignments.AType = 'EXAM'
      GROUP BY Assignments.SID) AS ExamPercentages
      LEFT OUTER JOIN 
      (SELECT AVG(IFNULL(Assignments.Score, 0)) AS QuizAvg, Assignments.SID AS SID
      FROM Assignments
      WHERE Assignments.AType = 'QUIZ'
      GROUP BY Assignments.SID) AS QuizPercentages
ON ExamPercentages.SID = QuizPercentages.SID
UNION
SELECT ExamPercentages.SID AS SID, COALESCE(QuizAvg, 0) * 0.4 + COALESCE(ExamAvg, 0) * 0.6 AS CourseAvg
FROM (SELECT AVG(IFNULL(Assignments.Score, 0)) AS ExamAvg, Assignments.SID AS SID
      FROM Assignments
      WHERE Assignments.AType = 'EXAM'
      GROUP BY Assignments.SID) AS ExamPercentages
      RIGHT OUTER JOIN 
      (SELECT AVG(IFNULL(Assignments.Score, 0)) AS QuizAvg, Assignments.SID AS SID
      FROM Assignments
      WHERE Assignments.AType = 'QUIZ'
      GROUP BY Assignments.SID) AS QuizPercentages
ON ExamPercentages.SID = QuizPercentages.SID;

DELIMITER //

-- Get grades as a percentage for each assignment
-- NEED TO ACCOUNT FOR UNATTEMPTED ASSIGNMENTS

    DROP PROCEDURE IF EXISTS HW4_ShowPercentages //

    CREATE PROCEDURE HW4_ShowPercentages(IN sid VARCHAR(4))
    BEGIN

    IF EXISTS(SELECT * FROM HW4_Student WHERE HW4_Student.SID = sid) THEN
        --  MODIFIED CODE FROM 4/19 CLASS
        SET @sql = NULL;

        -- accumulate into the variable named @sql a list of assignment names
        -- and expressions to that will get the associated scores, for use 
        -- as part of a later query of table HW4_RawScore
        SELECT
            GROUP_CONCAT(DISTINCT
            CONCAT(
                'max(case when aname = ''',
                aname,
                ''' then score end) as ''',aname,''''
            )
            ORDER BY atype DESC, aname ASC
            ) INTO @sql
        FROM HW4_Assignment;

        -- concatenate the assignment name list and associated expressions
        -- into a larger query string so we can execute it, but leave ?
        -- in place so we can plug in the specific sid value in a careful way
   
        -- why doesn't this work? should be same as one below which works for ShowRawScores but with AssignmentPercentages instead of HW4_RawScore
        SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, Assignments.Score AS Score, Assignments.AName AS AName
                             FROM HW4_Student, Assignments
                             WHERE HW4_Student.SID = Assignments.SID) ', 'SELECT sid, LName, FName, Sec, ',
                     @sql, ', CourseAvg,',
                     ' FROM StudentScores JOIN CourseAverages ON StudentScores.SID = CourseAverages.SID WHERE sid = ',
		     '?');

        /*SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, Assignments.Score AS Score, Assignments.AName AS AName
                             FROM HW4_Student, Assignments
                             WHERE HW4_Student.SID = Assignments.SID) ', 'SELECT sid, LName, FName, Sec, ',
                     @sql, 
                     ' FROM StudentScores WHERE sid = ',
		     '?');*
       

        -- alert the server we have a statement shell to set up
        PREPARE stmt FROM @sql;

         -- now execute the statement shell with a value plugged in for the ?
        EXECUTE stmt USING sid;

        -- tear down the prepared shell since no longer needed (we won't requery it)
        DEALLOCATE PREPARE stmt;
    ELSE
      SELECT CONCAT('ERROR: SID ', sid, ' not found') AS SID;
    END IF;
END; //

DELIMITER ;