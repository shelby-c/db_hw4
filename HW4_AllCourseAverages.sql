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

DROP PROCEDURE IF EXISTS HW4_AllCourseAverages //

CREATE PROCEDURE HW4_AllCourseAverages(IN sid VARCHAR(10))
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
