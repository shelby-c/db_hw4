  <!-- Shelby Coe (scoe4) !>
  <head><title>HW4 Show Raw Scores</title></head>
 <body>
<?php 
   /* echo "<h2>HW4 Show Raw Score</h2>";
    echo "<br>";

    // open a connection to dbase server
    include 'open.php'; //  NEED TO WRITE conf.php WITH APPROPRIATE CREDENTIALS

    // collect the posted value in a variable called $item
	$SID = $_POST['SID'];;

    // prepare query statement
    echo "SID: ";
    if(!empty($SID)) {
        echo $SID;
	    echo "<br><br>";
        // execute it, and if non-empty result, output each row of result
        if ($result = $conn->query("CALL HW4_ShowRawScores('".$SID."');")) {
            
            //echo "hi1";
            //echo $result;
            //echo "hi2";

            echo "<table border=\"2px solid black\">";
            echo "<tr><td>Show Raw Scores SID</td><td>LName</td><td>FName</td><td>Sec</td><td>AName</td><td>Score</td></tr>";
               foreach($result as $row){
                   
                  echo "<tr>";
                  echo "<td>".$row["SID"]."</td>";
                  echo "<td>".$row["LName"]."</td>";
                  echo "<td>".$row["FName"]."</td>";
                  echo "<td>".$row["Sec"]."</td>";
                  echo "<td>".$row["AName"]."</td>";
                  echo "<td>".$row["Score"]."</td>";
                  echo "</tr>";
                  
               }
            echo "</table>";
        } else {
           echo "Call to ShowRawScores failed<br>";
        }
    } else {
        echo "not set";
    }
    echo "<br>";

    
    $conn->close();*/
    
    //open a connection to dbase server 
	include 'open.php';

	// collect the posted value in a variable called $item
	$item = $_POST['SID'];

	// echo some basic header info onto the page
	echo "<h2>Student ID Raw Scores</h2><br>";
	echo "SID: ";

    // proceed with query only if supplied SID is non-empty
	if (!empty($item)) {
	   echo $item;
	   echo "<br><br>";

       // call the stored procedure we already defined on dbase
	   if ($result = $conn->query("CALL HW4_ShowRawScores('".$item."');")) {

	      echo "<table border=\"2px solid black\">";

          // output a row of table headers
	      echo "<tr>";
	      // collect an array holding all attribute names in $result
	      $flist = $result->fetch_fields();
          // output the name of each attribute in flist
	      foreach($flist as $fname){
	         echo "<td>".$fname->name."</td>";
	      }
	      echo "</tr>";

          // output a row of table for each row in result, using flist names
          // to obtain the appropriate attribute value for each column
	      foreach($result as $row){

              // reset the attribute names array
    	      $flist = $result->fetch_fields(); 
	          echo "<tr>";
	          foreach($flist as $fname){
                      echo "<td>".$row[$fname->name]."</td>";
              }
  	          echo "</tr>";
	      }
	      echo "</table>";

          } else {
             echo "Call to HW4_ShowRawScores failed<br>";
	  }   
   }

   // close the connection opened by open.php
   $conn->close();

?>
</body>