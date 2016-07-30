<#
SonyTVRemote
Version 0.2
Description: Скрипт автоматической генерации скриптов для мониторинга.
Pavel Satin (c) 2015
pslater.ru@gmail.com
#>

$ActionScript = $args[0]
$ComputerScript = $args[1]
$ProductName = $args[2]

$ScriptPath = 'C:\xStuff\GIT\MicroMonitoring\www\Scripts\'
$ScriptTmpl = 'C:\xStuff\GIT\MicroMonitoring\server\templates\'
$ScriptPathFile = $ScriptPath + 'remote-script-' + $ComputerScript + '.ps1'

# Удаляем старый скрипт
Remove-Item $ScriptPathFile

	$scriptNumber = Get-Random -maximum 999999 -minimum 100000
	$scriptNumberStr = "#" + $scriptNumber

###########################################################################
#Генерация скрипта перезагрузки
if ($ActionScript -eq 'reboot')
{

	Add-Content -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: reboot'
	Add-Content -path $ScriptPathFile -value ''

$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -path $ScriptPathFile -value $str
	Add-Content -path $ScriptPathFile -value '{'
	Add-Content -path $ScriptPathFile -value '	Restart-Computer'
	Add-Content -path $ScriptPathFile -value '}'
	Add-Content -path $ScriptPathFile -value ''

	
	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
	
}


###########################################################################
#Генерация скрипта выключения
if ($ActionScript -eq 'shutdown')
{

	Add-Content -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: shutdown'
	Add-Content -path $ScriptPathFile -value ''

$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -path $ScriptPathFile -value $str
	Add-Content -path $ScriptPathFile -value '{'
	Add-Content -path $ScriptPathFile -value '	Stop-Computer'
	Add-Content -path $ScriptPathFile -value '}'
	Add-Content -path $ScriptPathFile -value ''

	
	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
	
}


############################################################################
#Генерация скрипта установки обновлений и перезагрузка
if ($ActionScript -eq 'installupdates')
{

	Add-Content -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: installupdates'
	Add-Content -path $ScriptPathFile -value ''

	$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -path $ScriptPathFile -value $str
	Add-Content -path $ScriptPathFile -value '{'

	$str2 = gc $ScriptTmpl + 'installupdates.txt'

	Add-Content -path $ScriptPathFile -value $str2
	Add-Content -path $ScriptPathFile -value '}'

	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]

}


###########################################################################
#Генерация скрипта удаления программы (агенту нужны наивысшие права)
if ($ActionScript -eq 'uninstallproduct')
{

	Add-Content -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: uninstallproduct'
	Add-Content -path $ScriptPathFile -value ''

$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -path $ScriptPathFile -value $str
	Add-Content -path $ScriptPathFile -value '{'

$str2 = "	`$app = Get-WmiObject win32_product | Where-Object {`$_.name -match ""$ProductName""}"

	Add-Content -path $ScriptPathFile -value $str2
	Add-Content -path $ScriptPathFile -value "	`$app.uninstall() | Select-Object -Property returnvalue"

	
	Add-Content -path $ScriptPathFile -value '}'
	Add-Content -path $ScriptPathFile -value ''

	
	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
	
}

