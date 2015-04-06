function MultiHotfix {
$computers = cat C:\computers.txt
foreach ($computer in $computers) {
Get-HotFix -cn $computer | select CSName,Description,HotFixID,InstalledBy,InstalledOn | ConvertTo-Csv | Out-File -Append C:\hotfixreport2.csv
}
}