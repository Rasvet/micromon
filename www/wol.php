<?php

/*********************************************************************
 
wol.php
Пробуждение компьютера по WOL.


Павел Сатин <pslater.ru@gmail.com>
 22.10.2015
  

**********************************************************************/

require_once('config.php');


$str_q = $_GET["computer"];
if (!$str_q)
{
	echo "<a class='refresh' href='index.php'><b>Компьютеры</b></a><br /><br />";
	echo "Не передан параметр имя компьютера, нужно выполнять так: wol.php?computer=Имя_компьютера";
}
else
{


require('wsus_connect.php');

//echo "Connected to SQL Server\n";

$query = "SELECT ComputerTargetId
 FROM PUBLIC_VIEWS.vComputerTarget WHERE Name='" . $str_q . "'";

$stmt = $conn->query( $query ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){
	$ComputerID = $row['ComputerTargetId'];
}


$no_mac = true;

//echo "<table>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_NetworkAdapter'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
//echo "<tr>";
//echo  "<td>".$row['PropertyName']."</td>";
//echo  "<td>".$row['Value']."</td>";


if ($row['PropertyName'] == 'MACAddress')
{
	if (!empty($row['Value']))
	{
//echo "<td>";
$output = "";
		//$MACAddr = $row['Value'];
		$command = $commandWOL .$row['Value'];
		exec($command, $output);
		
		echo "<br />".$output[1]."<br />";
		$no_mac = false;
		
//echo "</td>";
	}

}

//echo "</tr>";		
}
//echo "</table>";
if ($no_mac)
{
	echo "<br />Для данного компьютера в базе данных не найдено ни одного MAC-адреса.<br />";
}


sqlsrv_free_stmt( $stmt);
sqlsrv_close( $conn);
}
exit;

?>


