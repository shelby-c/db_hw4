-- HW4_ShowAllRawScores.sql
/*
If given any valid password present in the HW4 passwords table, display a table showing the raw scores for all 
students in the course, sorted in ascending order by section number, then last name and finally first name. 
The display order within a given row and the column headers in the table should match that outlined in problem 1 above. 
If the supplied password is not present in the table, the PHP script should not display any table, but should 
instead display the descriptive message ”ERROR: Invalid password”. 
Use the filenames HW4 ShowAllRawScores.sql and HW4 ShowAllRawScores.php for this item.
*/

DELIMITER //

DROP PROCEDURE IF EXISTS HW4_ShowAllRawScores //

CREATE PROCEDURE HW4_ShowAllRawScores(IN Password VARCHAR(15))
BEGIN
    /*IF EXISTS(SELECT * FROM HW4_Password WHERE HW4_Password.CurPasswords = Password) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      SELECT HW4_Student.SID, HW4_Student.LName, HW4_Student.FName, HW4_Student.Sec, HW4_RawScore.AName, HW4_RawScore.Score
      FROM HW4_Student JOIN HW4_RawScore
      ON HW4_Student.SID = HW4_RawScore.SID
      ORDER BY HW4_Student.Sec ASC, HW4_Student.LName ASC, HW4_Student.FName ASC;
   ELSE
      SELECT '(all raw scores) ERROR: Invalid password' AS SID;  -- DELETE () BEFORE SUBMITTING
   END IF;*/

    IF EXISTS(SELECT * FROM HW4_Password WHERE HW4_Password.CurPasswords = Password) THEN
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
   
        /*SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_RawScore.Score AS Score, HW4_RawScore.AName AS AName
                             FROM HW4_Student, HW4_RawScore
                             WHERE HW4_Student.SID = HW4_RawScore.SID) ', 'SELECT sid, LName, FName, Sec, ',
                     @sql,
                     ' FROM StudentScores');*/
        /* SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_RawScore.Score AS Score, HW4_RawScore.AName AS AName
                             FROM HW4_Student, HW4_RawScore
                             WHERE HW4_Student.SID = HW4_RawScore.SID) ', 'SELECT sid, LName, FName, Sec, ',
                     @sql,
                     ' FROM StudentScores');*/

        SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_RawScore.Score AS Score, HW4_RawScore.AName AS AName
                             FROM HW4_Student, HW4_RawScore
                             WHERE HW4_Student.SID = HW4_RawScore.SID) ', 'SELECT sid, LName, FName, Sec, ',
                     @sql,
                     ' FROM StudentScores');

-- , 'ORDER BY StudentScores.Sec ASC, StudentScores.LName ASC, StudentScores.FName ASC'

        -- alert the server we have a statement shell to set up
        PREPARE stmt FROM @sql;

         -- now execute the statement shell with a value plugged in for the ?
        EXECUTE stmt -- USING sid;

        -- tear down the prepared shell since no longer needed (we won't requery it)
        DEALLOCATE PREPARE stmt;
    ELSE
      SELECT CONCAT('ERROR: SID ', sid, ' not found') AS SID;
    END IF;
END; //

DELIMITER ;