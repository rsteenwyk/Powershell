$Boottime = Get-WmiObject win32_operatingsystem | select @{LABEL='LastBootUpTime'

;EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}


$Acceptable = Get-Date -Date 2015-04-09 -Hour 20 -Minute 10

if ($Boottime.LastBootUpTime -lt $Acceptable)
{
shutdown.exe /r /t 90
}
else
{
Exit
}