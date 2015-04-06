#************************DO NOT EDIT********************************
$nse = New-Object -com Altiris.AeXNSEvent
$nse.To = "{1592B913-72F3-4C36-91D2-D4EDA21D2F96}"
$nse.Priority = 1
#************************DO NOT EDIT********************************

#Modify this varaible with the custom data class guid
$strDataClassGuid = "{9d835b8f-cc5b-4a15-923b-05a7fa23d96e}"

$objDCInstance = $nse.AddDataClass($strDataClassGuid)
$objDataClass = $nse.AddDataBlock($objDCInstance)

#Modify this varaible with the custom data class guid
$strDataClassGuid = "{9d835b8f-cc5b-4a15-923b-05a7fa23d96e}"

$objDCInstance = $nse.AddDataClass($strDataClassGuid)
$objDataClass = $nse.AddDataBlock($objDCInstance)




#Get Hotfix information
$Hotfix = Get-Hotfix

foreach ($patch in $Hotfix ) {
#Add new row of data
$objDataRow = $objDataClass.AddRow()
#Adds data to the columns
$objDataRow.SetField(0, $HotFix.HotFixID)
$objDataRow.SetField(1, $Hotfix.InstalledOn)
$objDataRow.SetField(2, $Hotfix.InstalledBy)
}

#Send the data
$nse.SendQueued()