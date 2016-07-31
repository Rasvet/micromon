<?php

/*********************************************************************
 
computer.php
Отчет - Параметры компьютера.

 Павел Сатин <pslater.ru@gmail.com>
 12.10.2015
  

**********************************************************************/

//Хидер osTicket

//require('staff.inc.php');
//require_once(STAFFINC_DIR.'header.inc.php');

echo "<br />";
echo "<link type='text/css' rel='stylesheet' href='css/monit.css'>";


$str_q = $_GET["computer"];
if (!$str_q)
{
	echo "<a class='refresh' href='index.php'><b>Компьютеры</b></a><br /><br />";
	echo "Не передан параметр имя компьютера, нужно выполнять так: computer.php?computer=Имя_компьютера";
}
else
{

echo "<h2>" . $str_q . "</h2>";
echo "<a class='refresh' href='index.php'><b>Компьютеры</b></a><br />";


require('wsus_connect.php');


//echo "Connected to SQL Server\n";

$query = "SELECT ComputerTargetId
 FROM PUBLIC_VIEWS.vComputerTarget WHERE Name='" . $str_q . "'";

//echo $str_q;
//echo $query;

$stmt = $conn->query( $query ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
   //print_r( $row['ComputerTargetId'] );
	$ComputerID = $row['ComputerTargetId'];
	//echo "<br />";
}


echo "<b>Установленное программное обеспечение</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>DisplayName</th><th>DisplayVersion</th><th>ProductID</th><th>Publisher</th><th>Language</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='WsusInternal_ARP'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) )
{
if ($row['PropertyName'] == 'DisplayName')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DisplayVersion')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'ProductID')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Publisher')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Language')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";		

}
	
}
echo "</table>";
echo "<br />";

echo "<a class='refresh' href='index.php'><b>Компьютеры</b></a><br />";
echo "<br />";

sqlsrv_free_stmt( $stmt);
sqlsrv_close( $conn);
}


?>



<?php
//Футер osTicket
//require_once(STAFFINC_DIR.'footer.inc.php');
?>

