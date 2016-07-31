<#
MicroMonitoring: Generate-remote-scripts
Version 1.5
Description: Скрипт автоматической генерации скриптов для мониторинга.
Pavel Satin (c) 2015
pslater.ru@gmail.com
#>

$ActionScript = $args[0]
$ComputerScript = $args[1]
$ProductName = $args[2]

$ScriptPath = 'C:\inetpub\wwwroot\status\Scripts\'
$ScriptTmpl = 'C:\inetpub\wwwroot\status\Scripts\templates\'
$ScriptPathFile = $ScriptPath + 'remote-script-' + $ComputerScript + '.ps1'

# Удаляем старый скрипт
Remove-Item $ScriptPathFile


	$scriptNumber = [guid]::NewGuid()
	$scriptNumberStr = "#" + $scriptNumber

###########################################################################
#Генерация скрипта перезагрузки
if ($ActionScript -eq 'reboot')
{

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: reboot'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value ''

$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $str
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '{'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '	Restart-Computer'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '}'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value ''

	
	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
	
}


###########################################################################
#Генерация скрипта выключения
if ($ActionScript -eq 'shutdown')
{

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: shutdown'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value ''

$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $str
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '{'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '	Stop-Computer'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '}'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value ''

	
	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
	
}


############################################################################
#Генерация скрипта установки обновлений и перезагрузка
if ($ActionScript -eq 'installupdates')
{

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: installupdates'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value ''

	$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $str
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '{'

	$strTemplate = $ScriptTmpl + 'installupdates.txt'

	gc $strTemplate |	Add-Content -Encoding UTF8 -path $ScriptPathFile
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '}'

	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]

}


###########################################################################
#Генерация скрипта удаления программы (агенту нужны наивысшие права)
if ($ActionScript -eq 'uninstallproduct')
{

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $scriptNumberStr
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '# Автоматический сгенерированный скрипт, действие: uninstallproduct'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value ''

$str = 'if ($env:computername -eq "' + $ComputerScript + '")'

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $str
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '{'

$str2 = "	`$app = Get-WmiObject win32_product | Where-Object {`$_.name -match ""$ProductName""}"

	Add-Content -Encoding UTF8 -path $ScriptPathFile -value $str2
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value "	`$app.uninstall() | Select-Object -Property returnvalue"

	
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value '}'
	Add-Content -Encoding UTF8 -path $ScriptPathFile -value ''

	
	Set-AuthenticodeSignature $ScriptPathFile @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]
	
}

