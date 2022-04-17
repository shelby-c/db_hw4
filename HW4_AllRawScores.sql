-- HW4_AllRawScores.sql
/*
If given any valid password present in the HW4 passwords table, display a table showing the raw scores for all 
students in the course, sorted in ascending order by section number, then last name and finally first name. 
The display order within a given row and the column headers in the table should match that outlined in problem 1 above. 
If the supplied password is not present in the table, the PHP script should not display any table, but should 
instead display the descriptive message ”ERROR: Invalid password”. 
Use the filenames HW4 ShowAllRawScores.sql and HW4 ShowAllRawScores.php for this item.
*/

DELIMITER //

DROP PROCEDURE IF EXISTS HW4_ShowRawScores //

CREATE PROCEDURE HW4_ShowRawScores(IN Password VARCHAR(10))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Password WHERE password = Password) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      SELECT HW4_Student.SID, HW4_Student.LName, HW4_Student.FName, HW4_Student.Sec, HW4_RawScore.AName, HW4_RawScore.Score
      FROM HW4_Student LEFT OUTER JOIN HW4_RawScore
      ON HW4_Student.SID = HW4_RawScore.SID;
   ELSE
       SELECT 'ERROR: Invalid password' AS SID;
   END IF;
END; //

DELIMITER ;
