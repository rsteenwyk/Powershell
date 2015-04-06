#========================================================================
# Created with: SAPIEN Technologies, Inc., PowerShell Studio 2012 v3.1.32
# Created on:   3/31/2014 2:35 PM
# Created by:   Rob Steenwyk
# Organization: Secure-24
# Filename: GetErrorWarningEvents     
#========================================================================


#Variables
$Date = Get-Date
#Change the string in AddDays to something else if you want more or less logs
$Date = $Date.AddDays(-7)
$timestamp = Get-Date -Format o | foreach {$_ -replace ":", "."}
$Computer = Get-Content $env:COMPUTERNAME
#Directory where you want log files to get saved, it will get saved within Directory variable + Computername folder. Ex. \\MSP-SPMPW02\NSCap\ExampleServerName
$Directory = "C:\Temp\"
$ComputerDirectory = $Directory + $Computer + "\"
$DirectoryExist = Test-Path -Path $ComputerDirectory -PathType Container


switch ($DirectoryExist) 
{
	true {"Directory exists"}
	false {New-Item -path $Directory -name $Computer -ItemType directory}
}


#Get Application, System and Security error and warning logs from the last 7 days.
$ApplicationErrors = Get-EventLog -LogName Application -EntryType Error,Warning -After $Date
#$SystemErrors = Get-EventLog -LogName System -EntryType Error,Warning -After $Date
#$SecurityErrors = Get-EventLog -LogName Security -EntryType Error,Warning -After $Date
$ApplicationErrors = $ApplicationErrors | Format-List

if ($ApplicationErrors -eq $null ) {"Nothing to write"} else { Out-File -InputObject $ApplicationErrors -FilePath C:\Temp\BEASTMODE\Computer.txt -Force -Width 1200}

