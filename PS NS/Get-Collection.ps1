#Copyright 2014 Rob Steenwyk - rsteenwyk@gmail.com
#
#
#Altiris.NS.StandardItems.Collection.NSDataSrcBasedWithExplicitResourceCollection
#
#


function global:Get-Filter {

    <#
    .SYNOPSIS
    Gets the Altiris/SMP collection (filter) based on name. Only works executing locally on SMP server.

    .DESCRIPTION
    Gets filter, with ability to search by name. Allows you to get the GUID for use in other functions, like Get-FilterMembership.
    #>

    [CmdletBinding(
	DefaultParameterSetName="Filter",
    ConfirmImpact='Low'
	)]

    param(

        [parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)]
        [string[]]$Filter="TestFilter"
        )
    
    


#Calls ItemManagement class into NSItem object, sets server as local computer, and authenticates with credentials of user
#running the script.
$NSItem = New-Object -ComObject Altiris.ASDK.NS.ItemManagement
$NSItem.TargetServer = "localhost"
$NSItem.Authenticate()

$NSItem.GetItemsByName("$Filter")



}
