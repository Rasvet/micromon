<?php

/*********************************************************************
 
computer_action.php
Генерация скрипта для удаленного клиента.


Павел Сатин <pslater.ru@gmail.com>
 22.10.2015
  

**********************************************************************/

require_once('config.php');

$str_q = $_GET["computer"];
if (!$str_q)
{
	echo "<a class='refresh' href='index.php'><b>Компьютеры</b></a><br /><br />";
	echo "Не передан параметр имя компьютера, нужно выполнять так: computer.php?computer=Имя_компьютера";
}
else
{


$str_q2 = $_GET["action"];
if (!$str_q2)
{
	echo "<a class='refresh' href='index.php'><b>Компьютеры</b></a><br /><br />";
	echo "Не передан параметр действие";

}
else
{

	$sctC = explode(".",$str_q);
	//echo $sctC[0];
	$output = "";

	$command = $commandGenScript .$str_q2." ".$sctC[0]."";
	exec($command, $output);
		
	echo "<br />".print_r($output)."<br />";


}

}


?>
