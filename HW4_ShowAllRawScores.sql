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

DROP PROCEDURE IF EXISTS HW4_AllRawScores //

CREATE PROCEDURE HW4_AllRawScores(IN Password VARCHAR(15))
BEGIN
    IF EXISTS(SELECT * FROM HW4_Password WHERE HW4_Password.CurPasswords = Password) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      SELECT HW4_Student.SID, HW4_Student.LName, HW4_Student.FName, HW4_Student.Sec, HW4_RawScore.AName, HW4_RawScore.Score
      FROM HW4_Student JOIN HW4_RawScore
      ON HW4_Student.SID = HW4_RawScore.SID
      ORDER BY HW4_Student.Sec ASC, HW4_Student.LName ASC, HW4_Student.FName ASC;

      /*
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

        -- why doesnt this show all of the tuples????
        SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_RawScore.Score AS Score, HW4_RawScore.AName AS AName
                             FROM HW4_Student, HW4_RawScore
                             WHERE HW4_Student.SID = HW4_RawScore.SID) ', 'SELECT SID, LName, FName, Sec, ',
                     @sql,
                     ' FROM StudentScores');
                     -- use dbase, see what prints, start at 29, see if one row or multiple (SELECT CONCAT(''', @sql, '''');
                     -- if one, sql issue
                     -- if many, php issue

-- , 'ORDER BY StudentScores.Sec ASC, StudentScores.LName ASC, StudentScores.FName ASC'


        DECLARE done INT DEFAULT FALSE;
        DECLARE current_sid INT;
        DECLARE sidcur CURSOR FOR SELECT HW4_Student.SID FROM HW4_Student;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

        OPEN sidcur;

        REPEAT
            FETCH sidcur INTO current_sid;

            -- alert the server we have a statement shell to set up
            PREPARE stmt FROM @sql;

             -- now execute the statement shell with a value plugged in for the ?
            EXECUTE stmt USING current_sid;

             -- tear down the prepared shell since no longer needed (we won't requery it)
            DEALLOCATE PREPARE stmt;
        UNTIL done
        END REPEAT;

        CLOSE sidcur;
      */
   ELSE
      SELECT 'ERROR: Invalid password' AS SID;  -- DELETE () BEFORE SUBMITTING
   END IF;
END; //

DELIMITER ;