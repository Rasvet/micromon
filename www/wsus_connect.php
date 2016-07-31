<?php

/*********************************************************************
 
wsus_connect.php
Подключение к БД WSUS для извлечения параметров. 


Павел Сатин <pslater.ru@gmail.com>
 22.10.2015
  

**********************************************************************/

try {
    $conn = new PDO("sqlsrv:Server=BD2\SQLEXPRESS;Database=SUSDB;", NULL, NULL);
    $conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
}

catch( PDOException $e ) {
	echo $e;
   die( "Error connecting to SQL Server" ); 
}


?>