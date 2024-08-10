<#
    Contains helper functions to use in the Pester tests
#>

function New-GlobalPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Level "Global" -Name "global.cshtml" -Xml $Xml
}

function New-WorkspacePolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Level "Workspace" -Name "test.workspace.cshtml" -Xml $Xml
}

function New-ProductPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Level "Product" -Name "test.product.cshtml" -Xml $Xml
}

function New-APIPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Level "API" -Name "test.api.cshtml" -Xml $Xml
}

function New-OperationPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Level "Operation" -Name "test.operation.cshtml" -Xml $Xml
}

function New-PolicyFragment([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Level "Fragment" -Name "test.fragment.cshtml" -Xml $Xml
}

function New-Policy([Parameter(Mandatory=$true)]$Level, [Parameter(Mandatory=$true)]$Name, [Parameter(Mandatory=$true)]$Xml)
{
    return [PSCustomObject]@{
        PSTypeName = "APIMPolicy" # This is necessary for the -Type filter on a Rule to work
        Name = $Name
        Level = $Level
        Content = [xml]$Xml
    }
}

function Invoke-CustomPSRule([Parameter(Mandatory=$true)]$InputObject, [Parameter(Mandatory=$true)]$Rule)
{
    # The Path should point to the directoy containing the rule files, else they won't be loaded
    # The Option should point to the PSRule configuraton file, else they conventions won't be loaded

    return Invoke-PSRule -InputObject $InputObject -Name $Rule -Path "$PSScriptRoot/../.ps-rule" -Option "$PSScriptRoot/../.ps-rule/ps-rule.yaml"
}

function Assert-RuleSucceeded {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline)][PSRule.Rules.RuleRecord]$RuleRecord
    )
    
    $RuleRecord | Should -not -BeNullOrEmpty
    $RuleRecord.IsSuccess() | Should -Be $True
}

function Assert-RuleFailedWithReason {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline)][PSRule.Rules.RuleRecord]$RuleRecord, 
        [Parameter(Mandatory=$true)][string]$ExpectedReasonPattern
    )
    
    $RuleRecord | Assert-RuleFailed
    $RuleRecord.Reason[0] | Should -BeLike $ExpectedReasonPattern
}

function Assert-RuleFailed {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline)][PSRule.Rules.RuleRecord]$RuleRecord
    )
    
    $RuleRecord | Should -not -BeNullOrEmpty
    $RuleRecord.IsSuccess() | Should -Be $False
    $RuleRecord.Reason.Length | Should -BeGreaterOrEqual 1
}

function Assert-RuleSkipped {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline)][PSRule.Rules.RuleRecord]$RuleRecord
    )
    
    $RuleRecord | Should -BeNull
}

function Assert-RuleSucceededForTarget {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][PSRule.Rules.RuleRecord[]]$RuleRecords,
        [Parameter(Mandatory=$true)][string]$TargetName
    )

    $ruleResult = $RuleRecords | Where-Object { $_.TargetName.EndsWith($TargetName) };
    $ruleResult | Should -Not -BeNullOrEmpty;
    $ruleResult.IsSuccess() | Should -Be $True
}

function Assert-RuleFailedForTarget {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][PSRule.Rules.RuleRecord[]]$RuleRecords,
        [Parameter(Mandatory=$true)][string]$TargetName
    )

    $ruleResult = $RuleRecords | Where-Object { $_.TargetName.EndsWith($TargetName) };
    $ruleResult | Should -Not -BeNullOrEmpty;
    $ruleResult.IsSuccess() | Should -Be $False
}