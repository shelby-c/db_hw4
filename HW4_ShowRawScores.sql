-- HW4_ShowRawScores.sql

-- Shelby Coe (scoe4)
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
   -- IF EXISTS(SELECT * FROM HW4_Student WHERE HW4_Student.SID = sid) THEN
--   IF CalcBidCount(item) > 0 THEN -- need it to read like "if exists"
      /*WITH EveryAssignment AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_Assignment.AName AS AName
                                FROM HW4_Student CROSS JOIN HW4_Assignment) -- all students matched with all assignments
      SELECT EveryAssignment.SID, EveryAssignment.LName, EveryAssignment.FName, EveryAssignment.Sec, EveryAssignment.AName, HW4_RawScore.Score
      FROM EveryAssignment LEFT OUTER JOIN HW4_RawScore
        ON HW4_RawScore.AName = EveryAssignment.AName AND EveryAssignment.SID = HW4_RawScore.SID
      WHERE HW4_RawScore.SID = sid;*/


      -- try 2
     /* WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_RawScore.Score AS Score, HW4_RawScore.AName AS AName
                             FROM HW4_Student, HW4_RawScore
                             WHERE HW4_Student.SID = HW4_RawScore.SID AND HW4_Student.SID = sid) -- all students matched with scores for assignments they attempted
      SELECT StudentScores.SID, StudentScores.LName, StudentScores.FName, StudentScores.Sec, HW4_Assignment.AName, StudentScores.Score
      FROM StudentScores RIGHT OUTER JOIN HW4_Assignment
        ON StudentScores.AName = HW4_Assignment.AName;*/
      -- WHERE StudentScores.SID = sid;

      /*
        SELECT WithSID.SID, WithSID.LName, WithSID.FName, WithSID.Sec, HW4_Assignment.AName, WithSID.Score
      FROM (SELECT * 
            FROM StudentScores
            WHERE StudentScores.SID = sid) AS WithSID RIGHT OUTER JOIN HW4_Assignment
        ON WithSID.AName = HW4_Assignment.AName;
      */
   /*ELSE
      SELECT CONCAT('ERROR: SID ', sid, ' not found') AS SID;
   END IF;*/
    
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
   
        /*SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_RawScore.Score AS Score, HW4_RawScore.AName AS AName
                             FROM HW4_Student, HW4_RawScore
                             WHERE HW4_Student.SID = HW4_RawScore.SID) ', 'SELECT sid, LName, FName, Sec, ',
                     @sql,
                     ' FROM StudentScores WHERE sid = ',
		     '?');*/

        SET @sql = CONCAT('WITH StudentScores AS (SELECT HW4_Student.SID AS SID, HW4_Student.LName AS LName, HW4_Student.FName AS FName, HW4_Student.Sec AS Sec, HW4_RawScore.Score AS Score, HW4_RawScore.AName AS AName
                             FROM HW4_Student, HW4_RawScore
                             WHERE HW4_Student.SID = HW4_RawScore.SID) ', 'SELECT sid, LName, FName, Sec, ',
                     @sql,
                     ' FROM StudentScores WHERE sid = ',
		     '?');
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
