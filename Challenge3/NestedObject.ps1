<#
        .SYNOPSIS
        Fetches value for a key from the input object.

        .DESCRIPTION
        Fetches value for a key from the input object.
        Takes both key and object as inputs.

        .INPUTS
        Key - examples - 'a/b/c'
        object - examples - {“a”:{“b”:{“c”:”d”}}}

        NOTE : In PowerShell, the above object is represented in form of a hashtable such as : 

            $Object = @{
                'a' = @{
                    'b' = @{
                        'c' = 'd'
                    }
                }
            }

        .OUTPUTS
        Value of the key
    #>

#Function Start : Get-Value    
function Get-Value {
    param (
        [pscustomobject] [Parameter(Mandatory = $true)] $Keys,
        [pscustomobject] [Parameter(Mandatory = $true)] $Object
    )

    try {
        #Splitting keys by '/' to get each individual key
        $Keys = $Keys.Split('/')
        
        $Obj = $object

        #Fetching values for each of the key 
        foreach($Key in $Keys){
            $Obj = $Obj.$Key
        }

        return $Obj
    }
    catch {
        #If the key provided is not in expected format
        Write-Host -ForegroundColor Red "The script was unable to fetch the value due to : $($_.exception.message)"
    }
}
#Function end : Get-value
