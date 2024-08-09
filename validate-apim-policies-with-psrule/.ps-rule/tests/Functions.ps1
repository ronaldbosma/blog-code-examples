<#
    Contains helper functions to use in the Pester tests
#>

function New-APIPolicy([Parameter(Mandatory=$true)]$xml)
{
    return [PSCustomObject]@{
        PSTypeName = "APIMPolicy.Types.API"
        Name = "api.cshtml"
        Content = [xml]$xml
    }
}

function New-OperationPolicy([Parameter(Mandatory=$true)]$xml)
{
    return [PSCustomObject]@{
        PSTypeName = "APIMPolicy.Types.Operation"
        Name = "operation.cshtml"
        Content = [xml]$xml
    }
}

function Invoke-CustomPSRule([Parameter(Mandatory=$true)]$inputObject, [Parameter(Mandatory=$true)]$rule)
{
    # The Path should point to the directoy containing the rule files, else they won't be loaded
    # The Option should point to the PSRule configuraton file, else they conventions won't be loaded

    return Invoke-PSRule -InputObject $inputObject -Name $rule -Path ".." -Option "../ps-rule.yaml"
}