<#
MicroMonitoring
Version 1.4

Description: Клиентский скрипт отправки состояния (Windows 2008/2012).

Pavel Satin (c) 2014
pslater.ru@gmail.com
#>

$url = 'http://www.mkucou.ru:8383'
$urlScript = 'http://www.mkucou.ru/monitoring/Scripts/remote-script-' + $env:computername + '.ps1'
$localScript = 'c:\Scripts\remote-script-' + $env:computername + '.ps1'
$localLog = 'c:\Scripts\remote-script-' + $env:computername + '.log'
$LocalCert = Get-AuthenticodeSignature c:\Scripts\client-srv.ps1




function Get-AntiVirusProduct { 
[CmdletBinding()] 
param ( 
[parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)] 
[Alias('name')] 
$computername=$env:computername 
) 

$AntiVirusProduct = Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct  -ComputerName $computername 

#Switch to determine the status of antivirus definitions and real-time protection. 
#The values in this switch-statement are retrieved from the following website: http://community.kaseya.com/resources/m/knowexch/1020.aspx 
switch ($AntiVirusProduct.productState) { 
"262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"} 
    "262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"} 
    "266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"} 
    "266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"} 
    "393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"} 
    "393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"} 
    "393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"} 
    "397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"} 
    "397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"} 
    "397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"} 
default {$defstatus = "Unknown" ;$rtstatus = "Unknown"} 
    } 

#Create hash-table for each computer 
$ht = @{} 
$ht.Computername = $computername 
$ht.Name = $AntiVirusProduct.displayName 
$ht.ProductExecutable = $AntiVirusProduct.pathToSignedProductExe 
$ht.'Definition Status' = $defstatus 
$ht.'Real-time Protection Status' = $rtstatus 

#Create a new object for each computer 
New-Object -TypeName PSObject -Property $ht 

}


$inventory = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, Version, Description, InstallDate, lastbootuptime, SerialNumber, CSDVersion
#$sysinfo = Get-WmiObject -Class Win32_ComputerSystem
#$antivirus = Get-AntiVirusProduct


$data = ("{`"Report_DateTime`":`"" + [System.DateTime]::Now + "`"," +
"`"Computer_Name`":`"" + $env:computername + "`"," +
"`"Domain_Name`":`"" + $env:userdnsdomain + "`"," +
"`"Computer_Description`":`"" + $inventory.Description + "`"," +
"`"OS_Name`":`"" + $inventory.Caption + "`"," +
"`"Ver_OS`":`"" + $inventory.Version + "`"," +
"`"OS_SP`":`"" + $inventory.CSDVersion + "`"," +
"`"Install_OS_Date`":`"" + [System.Management.ManagementDateTimeconverter]::ToDateTime($inventory.InstallDate) +"`"}")



$bytes = [System.Text.Encoding]::UTF8.GetBytes($data)
#Write-host $data

$cred = New-Object System.Net.NetworkCredential -ArgumentList $authUser,$authPass

$request = [Net.WebRequest]::Create($url)

$request.ServicePoint.Expect100Continue = $false

$request.Credentials = $cred
$request.ContentType = "application/json"

$request.Method = "POST"

$bytes = [System.Text.Encoding]::UTF8.GetBytes($data)

$request.ContentLength = $bytes.Length

$requestStream = [System.IO.Stream]$request.GetRequestStream()
$requestStream.write($bytes, 0, $bytes.Length)
$requestStream.Close()

$response = $request.GetResponse()


#Скачиваем скрипт 
Remove-Item $localScript
Invoke-WebRequest $urlScript -OutFile $localScript


$RemoteCert = Get-AuthenticodeSignature $localScript

if ($RemoteCert.SignerCertificate -eq $LocalCert.SignerCertificate)
{

    	#Write-host "Скрипт имеет туже подпись что и скрипт агента!"
	#Читаем первую строку, в ней должен быть номер сценария
	$fs = gc $localScript
	$scriptNumber = $fs[0]
	
	$tps = Test-Path -path $localLog
	if ($tps -eq "True")
	{
		#$fl = gc $localLog
	}
	else
	{
		Add-Content -path $localLog -value "#######"
		
	}
	$fl = gc $localLog
	$scriptLast = $fl[-1]

    	if ($scriptNumber -eq $scriptLast)
	{
		#Write-Host "Скрипт уже выполняли"
	}
	else
	{
		#Выполняем его
    		& $localScript
		Add-Content -path $localLog -value $scriptNumber
	}
    	
}

