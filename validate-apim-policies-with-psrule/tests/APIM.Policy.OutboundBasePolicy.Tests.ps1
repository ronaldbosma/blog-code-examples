<#
    Tests for APIM.Policy.OutboundBasePolicy rule
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
}

Describe "APIM.Policy.OutboundBasePolicy" {

    It "Should pass if base policy is the only policy in the outbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <outbound>
                    <base />
                </outbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        
        $result | Assert-RuleSucceeded
    }


    It "Should pass if base policy is any of the policies in the outbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <outbound>
                    <first />
                    <base />
                    <third />
                </outbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        $result | Assert-RuleSucceeded
    }


    It "Should fail if the base policy is missing from the outbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <outbound>
                    <not-base />
                </outbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should fail if the outbound section is empty" {
        $policy = New-APIPolicy @"
            <policies>
                <outbound />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should fail if the outbound section is missing" {
        $policy = New-APIPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*outbound*not exist*"
    }


    It "Should apply to workspace" {
        $policy = New-WorkspacePolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to product" {
        $policy = New-ProductPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to operation" {
        $policy = New-OperationPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        $result | Assert-RuleFailed
    }

    
    It "Should not apply to global" {
        $policy = New-GlobalPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        $result | Assert-RuleSkipped
    }

    
    It "Should not apply to policy fragment" {
        $policy = New-PolicyFragment "<fragment></fragment>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OutboundBasePolicy"
        $result | Assert-RuleSkipped
    }
}