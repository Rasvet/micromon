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

echo "<meta name='tip-namespace' content='computer.status'>";

?>



<?php
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

echo "<h2>" . $str_q . "</h2><br />";
echo "<hr><b>Задачи компьютера </b><i class='help-tip icon-question-sign' href='#computer-action' ></i><br />";
echo "<br /><a class='Icon shutdown no-pjax' target='_blank' href='computer_action.php?computer=".$str_q."&action=shutdown'><b>Завершение работы</b></a><br />";
echo "<br /><a class='Icon reboot no-pjax' target='_blank' href='computer_action.php?computer=".$str_q."&action=reboot'><b>Перезагрузка</b></a><br />";
echo "<br /><a class='Icon installupdate no-pjax' target='_blank' href='computer_action.php?computer=".$str_q."&action=installupdates'><b>Установка обновлений</b></a><br />";
echo "<hr>";
echo "<br /><a class='refresh' href='index.php'><b>Компьютеры</b></a><br />";



try {

$conn = new PDO("sqlsrv:Server=BD2\SQLEXPRESS;Database=SUSDB;", NULL, NULL);
 
   $conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
}

catch( PDOException $e ) {
	echo $e;
   die( "Error connecting to SQL Server" ); 
}

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

echo "<b>Система</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>Name</th><th>Manufacturer</th><th>Model</th><th>TotalPhysicalMemory</th></thead>";
$query2 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_ComputerSystem'";
$stmt = $conn->query( $query2 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'Name')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Manufacturer')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Model')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'TotalPhysicalMemory')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";

}
}
echo "</table>";
echo "<br />";
echo "<b>BIOS</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>Name</th><th>Version</th><th>Manufacturer</th><th>ReleaseDate</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_BIOS'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'Name')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Version')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Manufacturer')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'ReleaseDate')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";

}		
}
echo "</table>";
echo "<br />";

echo "<b>Процессор</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>DeviceID</th><th>Architecture</th><th>MaxClockSpeed</th><th>Name</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_Processor'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'DeviceID')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Architecture')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'MaxClockSpeed')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Name')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";

}	
}
echo "</table>";
echo "<br />";

echo "<b>Операционная система</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>Caption</th><th>OSLanguage</th><th>SerialNumber</th><th>Version</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_OperatingSystem'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'Caption')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'OSLanguage')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'SerialNumber')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Version')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";

}		
}
echo "</table>";
echo "<br />";

echo "<b>Физические диски</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>DeviceID</th><th>Caption</th><th>InterfaceType</th><th>Partitions</th><th>size</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_DiskDrive'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){
if ($row['PropertyName'] == 'DeviceID')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Caption')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'InterfaceType')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Partitions')
{
	echo  "<td>".$row['Value']."</td>";
	
} else if ($row['PropertyName'] == 'size')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";
}		
}
echo "</table>";
echo "<br />";

echo "<b>Логические диски</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>DeviceID</th><th>DriveType</th><th>VolumeName</th><th>FileSystem</th><th>Size</th><th>FreeSpace</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_LogicalDisk'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'DeviceID')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DriveType')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'VolumeName')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'FileSystem')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Size')
{
	echo  "<td>".$row['Value']."</td>";
	
} else if ($row['PropertyName'] == 'FreeSpace')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";
}
}
echo "</table>";
echo "<br />";

echo "<b>Видеоадаптеры</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>Description</th><th>AdapterRAM</th><th>DriverDate</th><th>VideoModeDescription</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_VideoController'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'Description')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'AdapterRAM')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DriverDate')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'VideoModeDescription')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";
}		
}
echo "</table>";
echo "<br />";

echo "<b>Мониторы</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>Name</th><th>MonitorManufacturer</th><th>PixelsPerXLogicalInch</th><th>PixelsPerYLogicalInch</th><th>ScreenHeight</th><th>ScreenWidth</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_DesktopMonitor'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'Name')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'MonitorManufacturer')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'PixelsPerXLogicalInch')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'PixelsPerYLogicalInch')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'ScreenHeight')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'ScreenWidth')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";
}		
}
echo "</table>";
echo "<br />";

echo "<b>Принтеры</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>DeviceID</th><th>Local</th><th>Network</th><th>Location</th><th>Comment</th><th>DriverName</th><th>ShareName</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_Printer'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'DeviceID')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Local')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Network')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Location')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Comment')
{
	echo  "<td>".$row['Value']."</td>";
	
} else if ($row['PropertyName'] == 'DriverName')
{
	echo  "<td>".$row['Value']."</td>";
	
} else if ($row['PropertyName'] == 'ShareName')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";
}	
}
echo "</table>";
echo "<br />";

/*************************************
*************************************/
echo "<b>Сетевые адаптеры</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>DeviceID</th><th>Name</th><th>Manufacturer</th><th>MACAddress</th><th>Speed</th><th>NetConnectionStatus</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_NetworkAdapter'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'DeviceID')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Name')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Manufacturer')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'MACAddress')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Speed')
{
	echo  "<td>".$row['Value']."</td>";
	
} else if ($row['PropertyName'] == 'NetConnectionStatus')
{
	echo  "<td>".$row['Value']."</td>";
	echo "</tr>";
}		
}
echo "</table>";
echo "<br />";


echo "<b>Конфигурация сетевых адаптеров</b>";
echo "<table id='ticketTable' border='0' cellspacing='0' cellpadding='0' width='100%'><thead><th>Index</th><th>Description</th><th>DHCPEnabled</th><th>DHCPServer</th><th>DNSDomain</th><th>DNSHostName</th><th>DomainDNSRegistrationEnabled</th><th>IPAddress</th><th>WINSPrimaryServer</th></thead>";
$query3 =  "SELECT ClassName, InstanceId, PropertyName, Value
 FROM PUBLIC_VIEWS.vComputerInventory WHERE ComputerTargetId='" . $ComputerID . "' AND ClassName='Win32_NetworkAdapterConfiguration'";
$stmt = $conn->query( $query3 ); 
while ( $row = $stmt->fetch( PDO::FETCH_ASSOC ) ){ 
if ($row['PropertyName'] == 'Index')
{
	echo "<tr>";
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'Description')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DHCPEnabled')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DHCPServer')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DNSDomain')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DNSHostName')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'DomainDNSRegistrationEnabled')
{
	echo  "<td>".$row['Value']."</td>";

} else if ($row['PropertyName'] == 'IPAddress')
{
	echo  "<td>".$row['Value']."</td>";
	
} else if ($row['PropertyName'] == 'WINSPrimaryServer')
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

