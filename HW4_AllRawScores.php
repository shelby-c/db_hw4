 <head><title>HW4 Show Raw Score</title></head>
 <body>
<?php 
    echo "<h2>HW4 Show Raw Score</h2>";
    echo "<br>";

    // open a connection to dbase server
    include 'open.php'; //  NEED TO WRITE conf.php WITH APPROPRIATE CREDENTIALS

    // prepare query statement
    $SID = $_POST['SID'];
    echo "The SID collected from the form was ";
    if(!empty($SID)) {
        echo $SID;
    } else {
        echo "not set";
    }
    echo ".<br>";

    // execute it, and if non-empty result, output each row of result
    if ($result = mysql_query($conn, $myQuery)){
        foreach($result as $row){
            // add formatting
            echo $row["SID"]." ".$row["LName"]." ".$row["FName"]." ".$row["sec"]." ".$row["AName"]." ".$row["Sec"]."<br>";
        }
    }
    $conn->close();

?>
</body>