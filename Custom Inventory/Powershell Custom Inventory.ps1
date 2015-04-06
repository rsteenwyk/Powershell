
#************************DO NOT EDIT********************************
$nse = New-Object -com Altiris.AeXNSEvent
$nse.To = "{1592B913-72F3-4C36-91D2-D4EDA21D2F96}"
$nse.Priority = 1
#************************DO NOT EDIT********************************

#Modify this variable with the custom data class guid
$strDataClassGuid = "{8c3303a2-3b94-4607-b05a-48cd9b4717e0}"

$objDCInstance = $nse.AddDataClass($strDataClassGuid)
$objDataClass = $nse.AddDataBlock($objDCInstance)

#Add new row of data
$objDataRow = $objDataClass.AddRow()

#Check PS version.
$Major = $host.Version.Major
$Minor = $host.Version.Minor
$Build = $host.Version.Build
$Revision = $host.Version.Revision

#Adds data to the columns
$objDataRow.SetField(0, $Major)
$objDataRow.SetField(1, $Minor)
$objDataRow.SetField(2, $Build)
$objDataRow.SetField(3, $Revision)
     
#Send the data
$nse.SendQueued()