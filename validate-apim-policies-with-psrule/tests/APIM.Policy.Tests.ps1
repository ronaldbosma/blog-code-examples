<#
    Integration tests that are executed on the src folder with the sample policies.
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
        $result = Invoke-PSRule -InputPath "./src/" -Option "./.ps-rule/ps-rule.yaml"
    }
    finally {
        Pop-Location
    }
}

Describe "APIM.Policy" {
    It "BackendBasePolicy" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.BackendBasePolicy' } );
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
    
    It "BackendForwardRequestGlobalPolicy" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.BackendForwardRequestGlobalPolicy' } );
        $ruleResults.Count | Should -Be 2

        Assert-RuleSucceededForTarget $ruleResults "good/global.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad/global.cshtml"
    }
    
    It "FileExtension" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.FileExtension' } );
        $ruleResults.Count | Should -Be 15

        Assert-RuleSucceededForTarget $ruleResults "good/global.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.workspace.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.product.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.api.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.operation.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad/global.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.workspace.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.product.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.api.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.operation.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "invalid-xml-1.operation.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "invalid-xml-2.operation.cshtml"

        Assert-RuleFailedForTarget $ruleResults "unknown-scope.cshtml"
    }

    It "InboundBasePolicy" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.InboundBasePolicy' } );
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
    
    It "OnErrorBasePolicy" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.OnErrorBasePolicy' } );
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
    
    It "OutboundBasePolicy" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.OutboundBasePolicy' } );
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
    
    It "RemoveSubscriptionKeyHeader" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.RemoveSubscriptionKeyHeader' } );
        $ruleResults.Count | Should -Be 2

        Assert-RuleSucceededForTarget $ruleResults "good/global.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad/global.cshtml"
    }
    
    It "UseBackendEntity" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.UseBackendEntity' } );
        $ruleResults.Count | Should -Be 12

        Assert-RuleSucceededForTarget $ruleResults "good/global.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.workspace.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.product.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.api.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.operation.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.fragment.cshtml"
        
        Assert-RuleFailedForTarget $ruleResults "bad/global.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.workspace.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.product.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.api.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.operation.cshtml"
        Assert-RuleFailedForTarget $ruleResults "bad.fragment.cshtml"
    }

    It "ValidXml" {
        $ruleResults = @( $result | Where-Object { $_.RuleName -eq 'APIM.Policy.ValidXml' } );
        $ruleResults.Count | Should -Be 14

        Assert-RuleSucceededForTarget $ruleResults "good/global.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.workspace.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.product.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.api.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.operation.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "good.fragment.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad/global.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.workspace.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.product.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.api.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.operation.cshtml"
        Assert-RuleSucceededForTarget $ruleResults "bad.fragment.cshtml"

        Assert-RuleFailedForTarget $ruleResults "invalid-xml-1.operation.cshtml"
        Assert-RuleFailedForTarget $ruleResults "invalid-xml-2.operation.cshtml"
    }
}