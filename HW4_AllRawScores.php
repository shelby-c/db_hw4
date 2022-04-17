 <head><title>HW4 All Raw Scores</title></head>
 <body>
<?php 
    echo "<h2>HW4 All Raw Scores</h2>";
    echo "<br>";

    // open a connection to dbase server
    include 'open.php'; 

    // collect the posted value in a variable called $item
	$password = $_POST['password'];;

    // prepare query statement
    echo "The password collected from the form was ";
    if(!empty($password)) {
        echo $password;
	    echo "<br><br>";
        // execute it, and if non-empty result, output each row of result
        if ($result = $conn->query("CALL HW4_ShowRawScores('".$password."');")) {
 
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
        } else {
           echo "Call to ShowRawScores failed<br>";
        }
    } else {
        echo "not set";
    }
    echo ".<br>";

    
    $conn->close();

?>
</body>