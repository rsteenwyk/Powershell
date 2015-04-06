$NSItem = New-Object -ComObject Altiris.ASDK.NS.ItemManagement
$nsItem.targetserver = "localhost"
$nsItem.Authenticate()
$PatchPolicy = $nsItem.GetItemsByType("Altiris.PatchManagementCore.Policies.PatchAgentPolicy")
$PatchPolicy | where {$_.Enabled -eq 'True'} | select Guid,Name,ParentFolderName,Enabled,AppliedToResourceTargets | out-file



function GET-PATCHPOLICY{

Param(
    [string]$status = 'True'
    )

$NSItem = New-Object -ComObject Altiris.ASDK.NS.ItemManagement
$nsItem.targetserver = "localhost"
$nsItem.Authenticate()
$PatchPolicy = $nsItem.GetItemsByType("Altiris.PatchManagementCore.Policies.PatchAgentPolicy")
$PatchPolicy | where {$_.Enabled -eq $status} | select Guid,Name,ParentFolderName,Enabled,AppliedToResourceTargets



}