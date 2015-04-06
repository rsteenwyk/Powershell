$Sophos = Get-Service | where {$_.DisplayName -like "Sophos*"} | where {$_.Status -eq "Running"}
$Sophos | Stop-Service





$Sophos | Start-Service


Install-WindowsFeature net-framework-core -source C:\sxs

c:\sql2012_installer\setup.exe /q /configurationfile=c:\sql2012_installer\configurationfile.ini