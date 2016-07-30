<?php

/*********************************************************************
 
download_rdp.php
Отдача rdp файла.

 Павел Сатин <pslater.ru@gmail.com>
 19.10.2015
  

**********************************************************************/




$str_q = $_GET["computer"];
if (!$str_q)
{
	
	#echo "Не передан параметр имя компьютера, нужно выполнять так: _download_rdp.php?computer=Имя_компьютера";
}
else
{

$temp = tmpfile();


fwrite($temp, "screen mode id:i:2\r\n");
fwrite($temp, "use multimon:i:0\r\n");
#fwrite($temp, "desktopwidth:i:1280\r\n");
#fwrite($temp, "desktopheight:i:1024\r\n");
fwrite($temp, "session bpp:i:32\r\n");
#fwrite($temp, "winposstr:s:0,1,0,0,1024,724\r\n");
fwrite($temp, "compression:i:1\r\n");
fwrite($temp, "keyboardhook:i:2\r\n");
fwrite($temp, "audiocapturemode:i:0\r\n");
fwrite($temp, "videoplaybackmode:i:1\r\n");
fwrite($temp, "connection type:i:2\r\n");
fwrite($temp, "displayconnectionbar:i:1\r\n");
fwrite($temp, "disable wallpaper:i:1\r\n");
fwrite($temp, "allow font smoothing:i:0\r\n");
fwrite($temp, "allow desktop composition:i:0\r\n");
fwrite($temp, "disable full window drag:i:1\r\n");
fwrite($temp, "disable menu anims:i:1\r\n");
fwrite($temp, "disable themes:i:0\r\n");
fwrite($temp, "disable cursor setting:i:0\r\n");
fwrite($temp, "bitmapcachepersistenable:i:1\r\n");
fwrite($temp, "full address:s:" . $str_q . "\r\n");
fwrite($temp, "audiomode:i:0\r\n");
fwrite($temp, "redirectprinters:i:1\r\n");
fwrite($temp, "redirectcomports:i:0\r\n");
fwrite($temp, "redirectsmartcards:i:1\r\n");
fwrite($temp, "redirectclipboard:i:1\r\n");
fwrite($temp, "redirectposdevices:i:0\r\n");
fwrite($temp, "redirectdirectx:i:1\r\n");
fwrite($temp, "autoreconnection enabled:i:1\r\n");
fwrite($temp, "authentication level:i:2\r\n");
fwrite($temp, "prompt for credentials:i:0\r\n");
fwrite($temp, "negotiate security layer:i:1\r\n");
fwrite($temp, "remoteapplicationmode:i:0\r\n");
fwrite($temp, "alternate shell:s:\r\n");
fwrite($temp, "shell working directory:s:\r\n");
fwrite($temp, "gatewayusagemethod:i:2\r\n");
fwrite($temp, "gatewaycredentialssource:i:0\r\n");
fwrite($temp, "gatewayprofileusagemethod:i:1\r\n");
fwrite($temp, "promptcredentialonce:i:1\r\n");
fwrite($temp, "use redirection server name:i:0\r\n");
fwrite($temp, "drivestoredirect:s:\r\n");
fwrite($temp, "networkautodetect:i:1\r\n");
fwrite($temp, "bandwidthautodetect:i:1\r\n");
fwrite($temp, "enableworkspacereconnect:i:0\r\n");
fwrite($temp, "gatewaybrokeringtype:i:0\r\n");
fwrite($temp, "rdgiskdcproxy:i:0\r\n");
fwrite($temp, "kdcproxyname:s:\r\n");


list($cn, $dn, $ds) = explode(".", $str_q);
if ($dn == 'MKUCOU')
{
	fwrite($temp, "gatewayhostname:s:rdp.mkucou.ru\r\n");
} else if ($dn == 'UKRGO')
{
	fwrite($temp, "gatewayhostname:s:ukrgo.remotewebaccess.com\r\n");
} else if ($dn == 'RKM')
{
	fwrite($temp, "gatewayhostname:s:ukrgo-rkm.remotewebaccess.com\r\n");
}



	#header('HTTP/1.1 200 OK');
	#header('Content-Description: File Transfer');
	#header('Content-type: application/octet-stream');
	#header('Content-transfer-encoding: binary');
	#header('Content-Type: application/file');
	#header('Cache-control: private');
	#header('Content-type: application/force-download');
	#header('Expires: 0');
        #header('Cache-Control: must-revalidate');
        #header('Pragma: public');
	#header('X-Accel-Redirect: ' . $temp);


header('Content-Disposition: attachment; filename=' . $str_q . '.rdp');
header("Content-Length: ".filesize($temp));

fseek($temp, 0);
echo fread($temp, 8192);

fclose($temp);

exit;

}

?>
