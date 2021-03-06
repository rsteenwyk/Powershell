$new_NSC = @()
$date = Get-Date -format M.d.yyyy
$NSC_File = "C:\Nsclientpp\nsc.ini"
$NSC_File_bak = "C:\Nsclientpp\nsc.ini.$date.bak"
$NSC = Get-Content $NSC_File

if ((Test-Path $NSC_File_bak) -eq $false) {
	copy-item -path $NSC_File -destination $NSC_File_bak
} else {
	$random = Get-Random
	copy-item -path $NSC_File -destination "C:\Nsclientpp\nsc.ini.$random.bak"
}

# DCE Zenoss Collector Network - 10.117.181.0/24
# DCD Zenoss Collector Network - 10.113.181.0/24
# DCB Zenoss Collector Network - 10.112.181.0/24
# DCE MSP Nagios Server - 10.118.140.8
# DCD MSP Nagios Server - 10.114.140.8
# DCB MSP Nagios Server - 10.112.200.8

$IPtoAdd = '10.112.181.0/24,10.113.181.0/24,10.117.181.0/24,10.112.200.8,10.114.140.8,10.118.140.8'

ForEach ($line in $NSC) {
    If ($line -match "allowed_hosts=") {
        If ($line -notmatch $IPtoAdd) {
            $line += "," + $IPtoAdd
        } ElseIf ($line -match $IPtoAdd) {
            Exit
        }
    }
    $new_NSC += $line
}

Remove-Item $NSC_File
Out-File -InputObject $new_NSC -FilePath $NSC_File -Encoding ASCII -Force -Confirm:$false

Restart-Service NSClientpp