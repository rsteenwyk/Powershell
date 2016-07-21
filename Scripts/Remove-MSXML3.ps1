#This requires -Version 2 -Modules NTFSSecurity
#Written by Rob Steenwyk - rsteenwyk@gmail.com 
#This script was written to be ran within the context of Altiris/SCCM/GPO login script as it assumes it will be ran as the SYSTEM account. 
#This script only unregisters and renames XML 3 DLL's - it will not touch XML 4, recommend you use the uninstaller for those. 
#Errors will be output to C:\RemoveMSXMLLog.txt 

#Import NTFS Security Module - needs to already be copied to C:\Windows\System32\WindowsPowerShell\v1.0\Modules 
#NTFS Security Module can be downloaded from https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85 
#NOTE - if attempting to import on PS v2, you will need to modify the NTFSSecurity.psd1 line two from "RootModule" to "ModuleToProcess" 
#If unable to import it will exit the script with exit 1000 without proceeding. 

$XML3Status = Get-ItemProperty -Path 'HKLM:\Software\S24' -Name 'XML3Status'
if ($XML3Status.XML3Status -eq 'Uninstalled') 
{
  Exit 0
} 

Try 
{
  Import-Module -Name ntfssecurity -ErrorAction Stop
} 
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to import NTFSSecurity Module due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
  Exit 1000 
} 

#Get XML 3 DLL folders. Exit 1010 if error. 
Try 
{ 
  $XMLDLLFolders = Get-ChildItem -Path C:\Windows\WinSxS -Recurse -ErrorAction Stop | Where-Object -FilterScript {
    $_.PSiscontainer -eq $true -and $_.Name -like '*msxml30*'
  }
  $XMLDLLString = $XMLDLLFolders |
  Get-ChildItem -Recurse -Include *.dll -ErrorAction Stop |
  Select-Object -ExpandProperty FullName 
  $XMLDLLObject = $XMLDLLFolders | Get-ChildItem -Recurse -Include *.dll -ErrorAction Stop 
  $XMLDLLFoldersFullPath = $XMLDLLFolders | Select-Object -ExpandProperty FullName
} 
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to parse XML folders due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
  Exit 1010 
} 



#Silently unregister each DLL file 
foreach ($path in $XMLDLLString) 
{
  Start-Process -FilePath 'regsvr32.exe' -ArgumentList "/u /s $path"
} 

#Get original NTFS Access for later restoration. Exit 1040 if failure. 
Try 
{
  $NTFSAccessOriginal = $XMLDLLFolders |
  Select-Object -First 1 |
  Get-NTFSAccess -ErrorAction Stop
} 
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to backup NTFS access due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
  Exit 1040 
} 
 

#Set NTFS Owner and Access to allow SYSTEM account full access. 
try 
{
  foreach ($folder in $XMLDLLFoldersFullPath) 
  {
    Set-NTFSOwner -Path $folder -Account S-1-5-18 -ErrorAction Stop
  }
}
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to set SYSTEM as owner on $folder due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
} 

try 
{
  foreach ($folder in $XMLDLLFoldersFullPath)
  {Add-NTFSAccess -Path $folder -Account S-1-5-18 -AccessRights FullControl -InheritanceFlags ObjectInherit}
} 
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to set full permissions for SYSTEM on $folder due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
} 



#Rename all DLL files with extension .old. Exit with 1050 if unable to rename. 
#This is failing, work on this with some dummy files. 
Try 
{
  foreach ($file in $XMLDLLObject) 
  { 
    $NewFileName = $file.FullName + '.old' 
    Rename-Item $file.FullName $NewFileName -ErrorAction Stop 
  } 
}
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to rename $file.FullName due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
  Exit 1050 
} 
 


#set folder owner back to TrustedInstaller and access back or original. Exit 1060 if unable to do so. 
try 
{ 
  foreach ($folder in $XMLDLLFoldersFullPath) 
  {
    Set-NTFSOwner -Path $folder -Account 'NT SERVICE\TrustedInstaller' -ErrorAction Stop 
    $NTFSAccessOriginal | Add-NTFSAccess -Path $folder -ErrorAction Stop
    Get-NTFSAccess -Path $folder -Account S-1-5-18 | Remove-NTFSAccess
  }
}
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to set owner or access on $folder due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
  Exit 1060 
} 


#Create reg key for Altiris to track compliance, exit 1070 if error. 
Try 
{ 
  New-Item -Path 'HKLM:\Software\S24'
  New-ItemProperty -Path 'HKLM:\Software\S24' -Name 'XML3Status' -Value 'Uninstalled' -Force
  exit 0
} 
Catch 
{ 
  $ErrorMessage = $_.Exception.Message 
  $time = Get-Date 
  "Unable to set uninstalled registry key due to: $ErrorMessage at $time" | Out-File -FilePath C:\RemoveMSXMLLog.txt -Append -Force 
  Exit 1070 
}
