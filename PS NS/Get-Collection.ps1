#Copyright 2014 Rob Steenwyk - rsteenwyk@gmail.com
#
#
#Altiris.NS.StandardItems.Collection.NSDataSrcBasedWithExplicitResourceCollection
#
#


function global:Get-NSFilter {

    <#
    .SYNOPSIS
    Gets the Altiris/SMP collection (filter) based on name. Only works executing locally on SMP server.

    .DESCRIPTION
    Gets filter, with ability to search by name. Allows you to get the GUID for use in other functions, like Get-NSFilterMembership.
    #>

    [CmdletBinding(
	DefaultParameterSetName="Filter",
    ConfirmImpact='Low'
	)]

    param
     (

        [parameter(Mandatory=$True,
        ValueFromPipeline=$True,
        ValueFromPipelineByPropertyName=$True,
        HelpMessage='What filter are you looking for? Remember to use an exact name.')]
        
        [string[]]$Filter= "All Computers"
     
        #[string]]]$GUID = 'eb3a1a12-e1c7-4431-b060-f0333e4e488c'
     
     )
    

    begin {
    Write-Verbose "Attempting to connect to Altiris COM objects, using credentials scripts is running under, presumed SMP Administrators. Presumed to be on Notification Server."
    $NSItem = New-Object -ComObject Altiris.ASDK.NS.ItemManagement
    $NSItem.TargetServer = "localhost"
    $NSItem.Authenticate()
    }    


    process {

$NSItem.GetItemsByName("$Filter")


}


}