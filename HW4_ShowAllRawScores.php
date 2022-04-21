<head><title>HW4 Show All Raw Scores</title></head>
 <body>
<?php 
    echo "<h2>HW4 Show All Raw Scores</h2>";
    echo "<br>";

    // open a connection to dbase server
    include 'open.php'; 

    // collect the posted value in a variable called $item
	$password = $_POST['password'];;

    // prepare query statement
    echo "Password: ";
    if(!empty($password)) {
        echo $password;
	    echo "<br><br>";
        // execute it, and if non-empty result, output each row of result
        if ($result = $conn->query("CALL HW4_AllRawScores('".$password."');")) {
 
            echo "<table border=\"2px solid black\">";
            echo "<tr><td>SID</td><td>LName</td><td>FName</td><td>Sec</td><td>AName</td><td>Score</td></tr>";
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

            /*
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
        */
        } else {
           echo "Call to AllRawScores failed<br>";
        }
    } else {
        echo "not set";
    }
    echo "<br>";

    
    $conn->close();

?>
</body>