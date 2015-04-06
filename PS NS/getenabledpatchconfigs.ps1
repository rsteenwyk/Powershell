#Gets the enabled patch configurations and outputs to a text file with the name "EnabledPatchPolicy Year-Month-Day-Minute-Second"

$NSItem = New-Object -ComObject Altiris.ASDK.NS.ItemManagement
$nsItem.targetserver = "localhost"
$nsItem.Authenticate()
$PatchPolicy = $nsItem.GetItemsByType("Altiris.PatchManagementCore.Policies.PatchAgentPolicy")
$PatchPolicy | where {$_.Enabled -eq 'True'} | select Name,ParentFolderName,Enabled | Sort-Object -Property Name | Format-List | out-file "C:\scripts\getpatchsettings\EnabledPatchPolicy $(get-date -f yyyy-MM-dd-m-s).txt"