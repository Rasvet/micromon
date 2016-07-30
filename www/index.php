<?php

/*********************************************************************

computers.php
Отчет - Список компьютеров с состоянием.


Павел Сатин <pslater.ru@gmail.com>
 20.09.2015


19.10.2015 - Добавлена загрузка rdp файла
**********************************************************************/

//Хидер osTicket
//require('staff.inc.php');
//require_once(STAFFINC_DIR.'header.inc.php');

echo "<meta name='tip-namespace' content='computer.status'>";

?>


<?php
//Функция декодирования esc последовательностей в русские буквы
function Escape_win ($path) { 
 $path = strtoupper ($path); 
 return strtr($path, array("\U0430"=>"а", "\U0431"=>"б", "\U0432"=>"в", 
 "\U0433"=>"г", "\U0434"=>"д", "\U0435"=>"е", "\U0451"=>"ё", "\U0436"=>"ж", "\U0437"=>"з", "\U0438"=>"и", 
 "\U0439"=>"й", "\U043A"=>"к", "\U043B"=>"л", "\U043C"=>"м", "\U043D"=>"н", "\U043E"=>"о", "\U043F"=>"п", 
 "\U0440"=>"р", "\U0441"=>"с", "\U0442"=>"т", "\U0443"=>"у", "\U0444"=>"ф", "\U0445"=>"х", "\U0446"=>"ц", 
 "\U0447"=>"ч", "\U0448"=>"ш", "\U0449"=>"щ", "\U044A"=>"ъ", "\U044B"=>"ы", "\U044C"=>"ь", "\U044D"=>"э", 
 "\U044E"=>"ю", "\U044F"=>"я", "\U0410"=>"А", "\U0411"=>"Б", "\U0412"=>"В", "\U0413"=>"Г", "\U0414"=>"Д", 
 "\U0415"=>"Е", "\U0401"=>"Ё", "\U0416"=>"Ж", "\U0417"=>"З", "\U0418"=>"И", "\U0419"=>"Й", "\U041A"=>"К", 
 "\U041B"=>"Л", "\U041C"=>"М", "\U041D"=>"Н", "\U041E"=>"О", "\U041F"=>"П", "\U0420"=>"Р", "\U0421"=>"С", 
 "\U0422"=>"Т", "\U0423"=>"У", "\U0424"=>"Ф", "\U0425"=>"Х", "\U0426"=>"Ц", "\U0427"=>"Ч", "\U0428"=>"Ш", 
 "\U0429"=>"Щ", "\U042A"=>"Ъ", "\U042B"=>"Ы", "\U042C"=>"Ь", "\U042D"=>"Э", "\U042E"=>"Ю", "\U042F"=>"Я")); 
 } 
?>

<?php
echo "<br />";



echo "<link type='text/css' rel='stylesheet' href='css/monit.css'>";

$str_q = $_GET["q"];
if ($str_q == '')
{
	$str_q = '%';
}

$host='localhost'; // имя хоста 
$database='micromon'; // имя базы данных 
$user='micromon_user'; // имя пользователя
$pswd='Z123456z'; // пароль


echo "<h2>Мониторинг хостов</h2><br />";



echo "<form action='index.php' method='get' id='ticketSearchForm'>
    
    <input type='text' name='q' size='20' value=''>
    
    <input type='submit' value='Поиск'>
<i class='help-tip icon-question-sign' href='#mon-search' ></i>
</form>";



echo "<a class='refresh' href='index.php'><b>Обновить</b></a>";

echo "<br />";
echo "<br />";



echo "<table border='0' cellspacing='0' cellpadding='0' width='100%'>";
echo "<thead>";
echo "<th  width='16' height='25' title='Состояние и запуск RDP сессии'>RD</th><th  width='16' height='25' title='Аппаратные характеристики'>HW</th><th  width='16' height='25' title='Установленное ПО'>SW</th><th  width='16' height='25' title='Функция WOL'>WL</th><th>Имя компьютера</th><th>Описание</th><th>Операционная система</th><th title='Брэндмауэр'>FW</th><th title='Автоматическое обновление'>AU</th><th title='Антивирусное ПО'>AV</th><th title='Антишпионское ПО'>AS</th><th title='Безопасность IE'>IS</th><th title='Котроль учетных записей'>UC</th><th title='Центр безопасности'>SC</th>";
echo "</thead>";


$dbh = mysql_connect($host, $user, $pswd) or die("Не могу соединиться с MySQL.");
mysql_select_db($database) or die("Не могу подключиться к базе.");

$query = "SELECT * FROM (SELECT * FROM ost_list_items WHERE ost_list_items.list_id = 5 ORDER BY ost_list_items.value ASC) AS q1 WHERE q1.value LIKE '%$str_q%' OR q1.properties LIKE '%$str_q%'";
$result = mysql_query($query)  or die(mysql_error());


while($row = mysql_fetch_array($result))
{

//$obj_prop = json_decode(Escape_win($row['properties']));
$obj_prop = json_decode($row['properties']);
//$obj_prop0 = json_decode($row['properties'], true);


echo "<tr>";

$s = $obj_prop->{'70'};
$date = strtotime($s);


if ($date > time()-7*60)
{
	if ($obj_prop->{'63'} == 'undefined')
	{
		echo "<td class='IconServerOn' title='Дата отчета: ".date('d/m/Y H:i:s', $date)."'><a class='no-pjax' href='download_rdp.php?computer=".$row['value']."'>rdp</a></td>";
	}
	else
	{
		echo "<td class='IconWorkstationOn' title='Дата отчета: ".date('d/m/Y H:i:s', $date)."'><a class='no-pjax' href='download_rdp.php?computer=".$row['value']."'>rdp</a></td>";
	}
}
else
{
	if ($obj_prop->{'63'} == 'undefined')
	{
		echo "<td class='IconServerOff' title='Дата отчета: ".date('d/m/Y H:i:s', $date)."'><a class='no-pjax' href='download_rdp.php?computer=".$row['value']."'>rdp</a></td>";
	}
	else
	{
		echo "<td class='IconWorkstationOff' title='Дата отчета: ".date('d/m/Y H:i:s', $date)."'><a class='no-pjax' href='download_rdp.php?computer=".$row['value']."'>rdp</a></td>";
	}
}
echo "<td title='Аппаратные характеристики'><a href='computer.php?computer=".$row['value']."'><img src='images/config.png' border='0'/></a></td>";
echo "<td title='Установленное ПО'><a href='software.php?computer=".$row['value']."'><img src='images/product.png' border='0'/></a></td>";
echo "<td title='Разбудить компьютер'><a href='wol.php?computer=".$row['value']."'><img src='images/link.png' border='0'/></a></td>";

echo "<td title='IP адрес: ".$obj_prop->{'60'}."'>".$row['value']."</td>";
echo "<td>".$obj_prop->{'62'}."</td>";
echo "<td title='Дата установки ОС: ".$obj_prop->{'74'}."'>".$obj_prop->{'61'}."</td>";

if ($obj_prop->{'63'} == 'undefined')
{
echo "<td class='IconInfoEncoded'></td>";
echo "<td class='IconInfoEncoded'></td>";
echo "<td class='IconInfoEncoded'></td>";
echo "<td class='IconInfoEncoded'></td>";
echo "<td class='IconInfoEncoded'></td>";
echo "<td class='IconInfoEncoded'></td>";
echo "<td class='IconInfoEncoded'></td>";
}
else
{
	if ($obj_prop->{'63'} == 'WSC_SECURITY_PROVIDER_HEALTH_GOOD'){
		echo "<td class='IconSuccessEncoded' title=".$obj_prop->{'63'}."></td>";
	} else if ($obj_prop->{'63'} == 'WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED'){
		echo "<td class='IconWarningEncoded' title=".$obj_prop->{'63'}."></td>";
	} else {
       	     	echo "<td class='IconErrorEncoded' title=".$obj_prop->{'63'}."></td>";
	}

	if ($obj_prop->{'64'} == 'WSC_SECURITY_PROVIDER_HEALTH_GOOD'){
		echo "<td class='IconSuccessEncoded' title=".$obj_prop->{'64'}."></td>";
	} else if ($obj_prop->{'64'} == 'WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED'){
		echo "<td class='IconWarningEncoded' title=".$obj_prop->{'64'}."></td>";
	} else {
		echo "<td class='IconErrorEncoded' title=".$obj_prop->{'64'}."></td>";
	}

	if ($obj_prop->{'65'} == 'WSC_SECURITY_PROVIDER_HEALTH_GOOD'){
		echo "<td class='IconSuccessEncoded' title='".$obj_prop->{'71'}."/".$obj_prop->{'72'}."/".$obj_prop->{'73'}."'></td>";
	} else if ($obj_prop->{'65'} == 'WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED'){
		echo "<td class='IconWarningEncoded' title='".$obj_prop->{'71'}."/".$obj_prop->{'72'}."/".$obj_prop->{'73'}."'></td>";
	} else {
		echo "<td class='IconErrorEncoded' title='".$obj_prop->{'71'}."/".$obj_prop->{'72'}."/".$obj_prop->{'73'}."'></td>";
	}

	if ($obj_prop->{'66'} == 'WSC_SECURITY_PROVIDER_HEALTH_GOOD'){
		echo "<td class='IconSuccessEncoded' title=".$obj_prop->{'66'}."></td>";
	} else if ($obj_prop->{'66'} == 'WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED'){
		echo "<td class='IconWarningEncoded' title=".$obj_prop->{'66'}."></td>";
	} else {
		echo "<td class='IconErrorEncoded' title=".$obj_prop->{'66'}."></td>";
	}

	if ($obj_prop->{'67'} == 'WSC_SECURITY_PROVIDER_HEALTH_GOOD'){
		echo "<td class='IconSuccessEncoded' title=".$obj_prop->{'67'}."></td>";
	} else if ($obj_prop->{'67'} == 'WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED'){
		echo "<td class='IconWarningEncoded' title=".$obj_prop->{'67'}."></td>";
	} else {
		echo "<td class='IconErrorEncoded' title=".$obj_prop->{'67'}."></td>";
	}

	if ($obj_prop->{'68'} == 'WSC_SECURITY_PROVIDER_HEALTH_GOOD'){
		echo "<td class='IconSuccessEncoded' title=".$obj_prop->{'68'}."></td>";
	} else if ($obj_prop->{'68'} == 'WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED'){
		echo "<td class='IconWarningEncoded' title=".$obj_prop->{'68'}."></td>";
	} else {
		echo "<td class='IconErrorEncoded' title=".$obj_prop->{'68'}."></td>";
	}

	if ($obj_prop->{'69'} == 'WSC_SECURITY_PROVIDER_HEALTH_GOOD'){
		echo "<td class='IconSuccessEncoded' title=".$obj_prop->{'69'}."></td>";
	} else if ($obj_prop->{'69'} == 'WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED'){
		echo "<td class='IconWarningEncoded' title=".$obj_prop->{'69'}."></td>";
	} else {
		echo "<td class='IconErrorEncoded' title=".$obj_prop->{'69'}."></td>";
	}

} ///////// not server if else

echo "</tr>";
}
echo "</table>";

echo "<br />";
echo "<a class='refresh' href='index.php'><b>Обновить</b></a>";
echo "<br />";
echo "<br />";

?>



<?php

//Футер osTicket

//require_once(STAFFINC_DIR.'footer.inc.php');
?>

