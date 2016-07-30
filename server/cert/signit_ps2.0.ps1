#####################################################################
# Sign PS1 Script.ps1
# Version 1.5
#
# Automatically sign PowerShell script from .PS1 file context menu
#
# Require PowerShell V2, not compatible with PowerShell 1.0
#
# Vadims Podans (c) 2009
# http://www.sysadmins.lv/
#####################################################################
#requires -Version 2.0

$FilePath = Read-Host "Specify path to hold SignIt.PS1"
if (Test-Path $FilePath) {
	$FilePath = $FilePath + "\" + "SignIt.ps1"
	$RegPath = "Registry::HKLM\Software\Classes\Microsoft.PowerShellScript.1\Shell\Sign It\command"
	$RegValue = "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -noprofile -command $FilePath '%1'"
	New-Item -Path $RegPath -Force -ErrorAction SilentlyContinue
	if (Test-Path $RegPath) {
		New-ItemProperty -Path $RegPath -Name "(Default)" -Value $RegValue
		New-Item -ItemType file -Path $FilePath -Force
		if (Test-Path $FilePath) {
			$exefile = 'param ($file)
function _msgbox_ ($title, $text, $type = "None") {
	[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
	$msg = [Windows.Forms.MessageBox]::Show($text, $title, [Windows.Forms.MessageBoxButtons]::ok,
	[Windows.Forms.MessageBoxIcon]::$type)
}
$cert = @(dir cert:\currentuser\my -codesigning)[0]
if (!$cert) {
	_msgbox_ -title "Error" -text "Here is no valid signing certificate!" -type "Error"
	exit
}
$status = Set-AuthenticodeSignature "$file" $cert -TimestampServer "http://timestamp.verisign.com/scripts/timstamp.dll"
if ($status.status -eq "Valid") {
	_msgbox_ -title "Success" -text "Script is now signed! Enjoy!"
} else {
	_msgbox_ -title "Error" -text $status.StatusMessage -type "Error"
}
exit'
			Set-Content -Path $FilePath -Value $exefile
			&$filepath $filepath
		}
		else {
			Write-Warning "Unable to create file in: $FilePath. Path is incorrect or you haven't sufficient permissions"
		}
	}
	else {
		Write-Warning "Unable to create registry key. May be you haven't sufficient permissions to HKLM hive"
	}
}
