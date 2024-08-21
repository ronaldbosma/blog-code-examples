<#
    Contains helper functions to use in the Pester tests
#>

function New-GlobalPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Scope "Global" -Name "global.cshtml" -Xml $Xml
}

function New-WorkspacePolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Scope "Workspace" -Name "test.workspace.cshtml" -Xml $Xml
}

function New-ProductPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Scope "Product" -Name "test.product.cshtml" -Xml $Xml
}

function New-APIPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Scope "API" -Name "test.api.cshtml" -Xml $Xml
}

function New-OperationPolicy([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Scope "Operation" -Name "test.operation.cshtml" -Xml $Xml
}

function New-PolicyFragment([Parameter(Mandatory=$true)]$Xml)
{
    return New-Policy -Scope "Fragment" -Name "test.fragment.cshtml" -Xml $Xml
}

function New-Policy([Parameter(Mandatory=$true)]$Scope, [Parameter(Mandatory=$true)]$Name, [Parameter(Mandatory=$true)]$Xml)
{
    return [PSCustomObject]@{
        PSTypeName = "APIM.Policy" # This is necessary for the -Type filter on a Rule to work
        Name = $Name
        Scope = $Scope
        Content = [xml]$Xml
    }
}

function Invoke-CustomPSRule([Parameter(Mandatory=$true)]$InputObject, [Parameter(Mandatory=$true)]$Rule)
{
    # The Path should point to the directory containing the rule files, else they won't be loaded
    # The Option should point to the PSRule configuration file, else they conventions won't be loaded

    return Invoke-PSRule -InputObject $InputObject -Name $Rule -Path "$PSScriptRoot/../.ps-rule" -Option "$PSScriptRoot/../.ps-rule/ps-rule.yaml"
}

function Assert-RulePassed {
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

function Assert-RulePassedForTarget {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][PSRule.Rules.RuleRecord[]]$RuleRecords,
        [Parameter(Mandatory=$true)][string]$TargetName
    )

    Assert-RuleOutcomeForTarget -RuleRecords $RuleRecords -TargetName $TargetName -ExpectedOutcome $True
}

function Assert-RuleFailedForTarget {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][PSRule.Rules.RuleRecord[]]$RuleRecords,
        [Parameter(Mandatory=$true)][string]$TargetName
    )

    Assert-RuleOutcomeForTarget -RuleRecords $RuleRecords -TargetName $TargetName -ExpectedOutcome $False
}

function Assert-RuleOutcomeForTarget {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][PSRule.Rules.RuleRecord[]]$RuleRecords,
        [Parameter(Mandatory=$true)][string]$TargetName,
        [Parameter(Mandatory=$true)][bool]$ExpectedOutcome
    )

    # The path separator can be either \ or /, so we change all to / to make the comparison work
    $TargetName = $TargetName.Replace("\", "/");

    $ruleResult = $RuleRecords | Where-Object { $_.TargetName.Replace("\", "/").EndsWith($TargetName) };
    $ruleResult | Should -Not -BeNullOrEmpty;
    $ruleResult.IsSuccess() | Should -Be $ExpectedOutcome
}