<?php
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
	
	$command = "powershell.exe C:\\xStuff\\GIT\\MicroMonitoring\\server\\Generate-remote-scripts.ps1 ".$str_q2." ".$sctC[0]."";
	//echo $command;
	exec($command, $output);
		
	echo "<br />".print_r($output)."<br />";


}

}


?>
