<#
        .SYNOPSIS
        Fetches Metadata for an Endpoint.

        .DESCRIPTION
        Fetches Metadata for an Endpoint.
        Takes the name of Endpoint as Input

        .INPUTS
        None.

        .OUTPUTS
        JSON Formatted output
    #>


#IMDS Server
$ImdsServer = "http://169.254.169.254"

#Api versions for endpoints
$ApiVersion = "2021-02-01"

#Type of endpoint to fetch metadata for
$InstanceEndpoint = $ImdsServer + "/metadata/instance"

#Function Start : Get-Metadata
function Get-Metadata {
    param (
        [pscustomobject] [Parameter(Mandatory = $true)] $InstanceEndpoint,
        [pscustomobject] [Parameter(Mandatory = $true)] $ApiVersion
    )

    try {
        #Initializing variable
        $Metadata = $null

        #Querying instance endpoint to fetch the metadata
        $Metadata = Invoke-RestMethod -Headers @{"Metadata" = "true" } -Method GET -Uri "$($InstanceEndpoint)?api-version=$($ApiVersion)" | ConvertTo-Json -Depth 64
        return $Metadata
    }
    catch {
        Write-Host -ForegroundColor Red "The script was unable to fetch metadata due to : $($_.exception.message)"
    }
    
}
#Function End : Get-Metadata

#Calling Function 
$Metadata = Get-Metadata -InstanceEndpoint $InstanceEndpoint -ApiVersion $ApiVersion

#Print Output
$Metadata