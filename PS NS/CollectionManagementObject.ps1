$NSCollection = New-Object -ComObject Altiris.ASDK.NS.CollectionManagement
$NSCollection.TargetServer = "localhost"
$NSCollection.Authenticate()


$NSItem.GetItemByGuid("8918c4b8-f6d0-45c3-bcb9-4628d264da20")