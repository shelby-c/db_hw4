-- HW4_ShowRawScores.sql
/*
Given a single SID identifier, display that single student’s information and raw scores 
on all assignments in the course. If the specified student has not attempted a quiz or test, 
display no score for that assessment. (Do not place an artificial 0 in the table; 
the table output should be blank if the assessment was not attempted.) The order of 
display of the information in the PHP-generated table should be: SID, lname, fname, section, 
then the raw scores for each assignment name in the course (as given in the HW4 Assignment table). 
The table headers for assignments displayed should match the assignment names. 
If the given SID does not exist in the database, the PHP script should not display any table, 
but should instead display a descriptive message of the form ”ERROR: SID XXXX not found”, 
where XXXX is replaced by the given SID. Use the filenames HW4 ShowRawScores.sql and
HW4 ShowRawScores.php for this item. 
*/

DELIMITER //

DROP PROCEDURE IF EXISTS HW4_ShowRawScores //

CREATE PROCEDURE HW4_ShowRawScores(IN sid VARCHAR(4))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Student WHERE HW4_Student.SID = sid) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      -- SELECT 'test' AS SID;
      WITH EveryAssignment AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_Assignment.AName AS AName
                                FROM HW4_Student JOIN HW4_Assignment)
      SELECT EveryAssignment.SID, EveryAssignment.LName, EveryAssignment.FName, EveryAssignment.Sec, EveryAssignment.AName, HW4_RawScore.Score
      FROM EveryAssignment JOIN HW4_RawScore
        ON HW4_RawScore.AName = EveryAssignment.AName AND EveryAssignment.SID = HW4_RawScore.SID
      WHERE HW4_RawScore.SID = sid;
   ELSE
      SELECT CONCAT('ERROR: SID ', sid, ' not found') AS SID;
   END IF;
END; //

DELIMITER ;
