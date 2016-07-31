<?php

try {
    $conn = new PDO("sqlsrv:Server=BD2\SQLEXPRESS;Database=SUSDB;", NULL, NULL);
    $conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
}

catch( PDOException $e ) {
	echo $e;
   die( "Error connecting to SQL Server" ); 
}


?>