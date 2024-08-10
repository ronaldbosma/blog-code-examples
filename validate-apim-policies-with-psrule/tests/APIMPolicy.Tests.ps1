<#
    Integration tests that are executed on the src folder with sample policies.
#>

BeforeAll {
    # Setup error handling
    $ErrorActionPreference = 'Stop';
    Set-StrictMode -Version latest;

    if ($Env:SYSTEM_DEBUG -eq 'true') {
        $VerbosePreference = 'Continue';
    }

    # Load functions
    . $PSScriptRoot/Functions.ps1


    # If you execute Invoke-PSRule from inside the test folder, no files will be analysed. So, we go up one level.
    Push-Location "$PSScriptRoot/.."
    try {
        # Analyse policies in src folder using PSRule
        $result = Invoke-PSRule -InputPath "./src" -Option "./.ps-rule/ps-rule.yaml"
    }
    finally {
        Pop-Location
    }
}

Describe "APIMPolicy" {
    It "APIMPolicy.Rules.BackendBasePolicy" {

        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIMPolicy.Rules.BackendBasePolicy' } );
        $ruleResults.Count | Should -Be 8

        Assert-RuleSucceededForTarget $ruleResults "good.workspace.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.product.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.api.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.operation.cshtml"
        
        Assert-RuleFailedForTarget $ruleResults "bad.workspace.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.product.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.api.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.operation.cshtml"
    }
}