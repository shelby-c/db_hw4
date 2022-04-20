<?php
    
    // collect login variable values
    include 'conf.php'; // PUT CREDENTIALS IN confphp

    // attempt to create connectuon to db
    $conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
    

    // report if success or failure
    if ($conn->connect_errno) {
        echo("Connect failed: \n".$conn->connect_error);
        exit();
    }  else {
        // REMOVE LATER
    }


?>