<#
    Contains helper functions to use in the Pester tests
#>

function New-APIPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return [PSCustomObject]@{
        PSTypeName = "APIMPolicy.Types.API" # This is necessary for the -Type filter on a Rule to work
        PolicyType = "APIMPolicy.Types.API"
        Name = "api.cshtml"
        Content = [xml]$Xml
    }
}

function New-OperationPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return [PSCustomObject]@{
        PSTypeName = "APIMPolicy.Types.Operation" # This is necessary for the -Type filter on a Rule to work
        PolicyType = "APIMPolicy.Types.Operation"
        Name = "operation.cshtml"
        Content = [xml]$Xml
    }
}

function Invoke-CustomPSRule([Parameter(Mandatory=$true)]$InputObject, [Parameter(Mandatory=$true)]$Rule)
{
    # The Path should point to the directoy containing the rule files, else they won't be loaded
    # The Option should point to the PSRule configuraton file, else they conventions won't be loaded

    return Invoke-PSRule -InputObject $InputObject -Name $Rule -Path "$PSScriptRoot/../.ps-rule" -Option "$PSScriptRoot/../.ps-rule/ps-rule.yaml"
}

function Assert-PSRuleSucceeded {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline)][PSRule.Rules.RuleRecord]$RuleRecord
    )
    
    $RuleRecord | Should -not -BeNullOrEmpty
    $RuleRecord.IsSuccess() | Should -Be $True
}

function Assert-PSRuleFailedWithReason {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline)][PSRule.Rules.RuleRecord]$RuleRecord, 
        [Parameter(Mandatory=$true)][string]$ExpectedReasonPattern
    )
    
    $RuleRecord | Should -not -BeNullOrEmpty
    $RuleRecord.IsSuccess() | Should -Be $False
    $RuleRecord.Reason.Length | Should -BeGreaterOrEqual 1
    $RuleRecord.Reason[0] | Should -BeLike $ExpectedReasonPattern
}
