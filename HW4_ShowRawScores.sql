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

CREATE PROCEDURE HW4_ShowRawScores(IN sid VARCHAR(10))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Student WHERE SID = sid) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      SELECT HW4_Student.SID, HW4_Student.LName, HW4_Student.FName, HW4_Student.Sec, HW4_RawScore.AName, HW4_RawScore.Score
      FROM HW4_Student LEFT OUTER JOIN HW4_RawScore
      ON HW4_Student.SID = HW4_RawScore.SID;
   ELSE
       SELECT 'ERROR: SID ' + sid+ 'not found' AS SID;
   END IF;
END; //

DELIMITER ;
