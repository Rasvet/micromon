#Создаем корневой сертификат
.\makecert.exe -n "CN=PowerShell Local Certificate Root" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv ps-mkucou-root.pvk ps-mkucou-root.cer -ss Root -sr localMachine

#Создаем сертификат издателя на основе нашего корневого
.\makecert.exe -pe -n "CN=PowerShell User" -ss MY -a sha1 -eku 1.3.6.1.5.5.7.3.3 -iv ps-mkucou-root.pvk -ic ps-mkucou-root.cer

#Подписываем конкретный файл
Set-AuthenticodeSignature c:\Scripts\remote-script.ps1 @(Get-ChildItem cert:\CurrentUser\My -codesign)[0]

#Подписываем все ps1 файлы в текущем каталоге и подкаталогах
$cert = @(dir cert:\currentuser\my -codesigning)[0]
dir -Include *.ps1 -Recurse | %{Set-AuthenticodeSignature "$_" $cert}

