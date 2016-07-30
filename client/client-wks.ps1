<#
MicroMonitoring
Version 1.4

Description: Клиентский скрипт отправки состояния (Windows 7/8/10).

Pavel Satin (c) 2014
pslater.ru@gmail.com
#>


$url = 'http://www.mkucou.ru:8383'
$urlScript = 'http://www.mkucou.ru/monitoring/Scripts/remote-script-' + $env:computername + '.ps1'
$localScript = 'c:\Scripts\remote-script-' + $env:computername + '.ps1'
$localLog = 'c:\Scripts\remote-script-' + $env:computername + '.log'
$LocalCert = Get-AuthenticodeSignature c:\Scripts\client-wks.ps1



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



# Define our C# functions to extract info from Windows Security Center (WSC) via Windows API so we can call from PowerShell
$wscDefinition = @"
        // WSC_SECURITY_PROVIDER as defined in Wscapi.h or http://msdn.microsoft.com/en-us/library/bb432509(v=vs.85).aspx
		[Flags]
        public enum WSC_SECURITY_PROVIDER : int
        {
            WSC_SECURITY_PROVIDER_FIREWALL = 1,				// The aggregation of all firewalls for this computer.
            WSC_SECURITY_PROVIDER_AUTOUPDATE_SETTINGS = 2,	// The automatic update settings for this computer.
            WSC_SECURITY_PROVIDER_ANTIVIRUS = 4,			// The aggregation of all antivirus products for this computer.
            WSC_SECURITY_PROVIDER_ANTISPYWARE = 8,			// The aggregation of all anti-spyware products for this computer.
            WSC_SECURITY_PROVIDER_INTERNET_SETTINGS = 16,	// The settings that restrict the access of web sites in each of the Internet zones for this computer.
            WSC_SECURITY_PROVIDER_USER_ACCOUNT_CONTROL = 32,	// The User Account Control (UAC) settings for this computer.
            WSC_SECURITY_PROVIDER_SERVICE = 64,				// The running state of the WSC service on this computer.
            WSC_SECURITY_PROVIDER_NONE = 0,					// None of the items that WSC monitors.
			
			// All of the items that the WSC monitors.
            WSC_SECURITY_PROVIDER_ALL = WSC_SECURITY_PROVIDER_FIREWALL | WSC_SECURITY_PROVIDER_AUTOUPDATE_SETTINGS | WSC_SECURITY_PROVIDER_ANTIVIRUS |
            WSC_SECURITY_PROVIDER_ANTISPYWARE | WSC_SECURITY_PROVIDER_INTERNET_SETTINGS | WSC_SECURITY_PROVIDER_USER_ACCOUNT_CONTROL |
            WSC_SECURITY_PROVIDER_SERVICE | WSC_SECURITY_PROVIDER_NONE
        }

        [Flags]
        public enum WSC_SECURITY_PROVIDER_HEALTH : int
        {
            WSC_SECURITY_PROVIDER_HEALTH_GOOD, 			// The status of the security provider category is good and does not need user attention.
            WSC_SECURITY_PROVIDER_HEALTH_NOTMONITORED,	// The status of the security provider category is not monitored by WSC. 
            WSC_SECURITY_PROVIDER_HEALTH_POOR, 			// The status of the security provider category is poor and the computer may be at risk.
            WSC_SECURITY_PROVIDER_HEALTH_SNOOZE, 		// The security provider category is in snooze state. Snooze indicates that WSC is not actively protecting the computer.
            WSC_SECURITY_PROVIDER_HEALTH_UNKNOWN
        }

		// as defined in http://msdn.microsoft.com/en-us/library/bb432506(v=vs.85).aspx
        [DllImport("wscapi.dll")]
        private static extern int WscGetSecurityProviderHealth(int inValue, ref int outValue);

		// code to call our interop function and return the relevant result based on what input value we provide
        public static WSC_SECURITY_PROVIDER_HEALTH GetSecurityProviderHealth(WSC_SECURITY_PROVIDER inputValue)
        {
            int inValue = (int)inputValue;
            int outValue = -1;

            int result = WscGetSecurityProviderHealth(inValue, ref outValue);

            foreach (WSC_SECURITY_PROVIDER_HEALTH wsph in Enum.GetValues(typeof(WSC_SECURITY_PROVIDER_HEALTH)))
                if ((int)wsph == outValue) return wsph;

            return WSC_SECURITY_PROVIDER_HEALTH.WSC_SECURITY_PROVIDER_HEALTH_UNKNOWN;
        }
"@

$wscType=Add-Type -memberDefinition $wscDefinition -name "wscType" -UsingNamespace "System.Reflection","System.Diagnostics" -PassThru

$inventory = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, Version, Description, InstallDate, lastbootuptime, SerialNumber, CSDVersion

$antivirus = Get-AntiVirusProduct


$data = ("{`"Report_DateTime`":`"" + [System.DateTime]::Now + "`"," +
"`"Computer_Name`":`"" + $env:computername + "`"," +
"`"Domain_Name`":`"" + $env:userdnsdomain + "`"," +
"`"Computer_Description`":`"" + $inventory.Description + "`"," +
"`"OS_Name`":`"" + $inventory.Caption + "`"," +
"`"Ver_OS`":`"" + $inventory.Version + "`"," +
"`"OS_SP`":`"" + $inventory.CSDVersion + "`"," +
"`"Install_OS_Date`":`"" + [System.Management.ManagementDateTimeconverter]::ToDateTime($inventory.InstallDate) + "`"," +
"`"Anti_Virus_Name`":`"" + $antivirus.Name + "`"," +
"`"Anti_Virus_Definiton_Status`":`"" + $antivirus.'Definition Status' + "`"," +
"`"Anti_Virus_Protection_Status`":`"" + $antivirus.'Real-time Protection Status' + "`"," +
"`"Firewall`":`"" + $wscType[0]::GetSecurityProviderHealth($wscType[1]::WSC_SECURITY_PROVIDER_FIREWALL) + "`"," +
"`"Auto_Update`":`"" + $wscType[0]::GetSecurityProviderHealth($wscType[1]::WSC_SECURITY_PROVIDER_AUTOUPDATE_SETTINGS) + "`"," +
"`"Anti_Virus`":`"" + $wscType[0]::GetSecurityProviderHealth($wscType[1]::WSC_SECURITY_PROVIDER_ANTIVIRUS) + "`"," + 
"`"Anti_Spyware`":`"" + $wscType[0]::GetSecurityProviderHealth($wscType[1]::WSC_SECURITY_PROVIDER_ANTISPYWARE) + "`"," + 
"`"Internet_Settings`":`"" + $wscType[0]::GetSecurityProviderHealth($wscType[1]::WSC_SECURITY_PROVIDER_INTERNET_SETTINGS) + "`"," +
"`"User_Account_Control`":`"" + $wscType[0]::GetSecurityProviderHealth($wscType[1]::WSC_SECURITY_PROVIDER_USER_ACCOUNT_CONTROL) + "`"," +
"`"WSC_Service`":`"" + $wscType[0]::GetSecurityProviderHealth($wscType[1]::WSC_SECURITY_PROVIDER_SERVICE) + "`"}")


$bytes = [System.Text.Encoding]::UTF8.GetBytes($data)

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

##################################################################
#Скачиваем скрипт 
Remove-Item $localScript

#В powershell 2.0 нет Invoke-WebRequest
#Invoke-WebRequest $urlScript -OutFile $localScript

$client = new-object System.Net.WebClient
$client.DownloadFile( $urlScript, $localScript )


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

