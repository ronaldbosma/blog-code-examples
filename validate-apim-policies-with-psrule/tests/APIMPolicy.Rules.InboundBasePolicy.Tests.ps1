<#
    Tests for APIMPolicy.Rules.InboundBasePolicy rule
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

Describe "APIMPolicy.Rules.InboundBasePolicy" {

    It "Should return true if base policy is the only policy in the inbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <base />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        
        $result | Assert-RuleSucceeded
    }


    It "Should return true if base policy is the first policy in the inbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <base />
                    <second />
                    <third />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        
        $result | Assert-RuleSucceeded
    }


    It "Should return false if base policy is NOT the first policy in the inbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <first />
                    <base />
                    <third />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*inbound.FirstChild.Name*first*"
    }


    It "Should return false if the base policy is missing from the inbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <not-base />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should return false if the inbound section is empty" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should return false if the inbound section is missing" {
        $policy = New-APIPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*inbound*not exist*"
    }


    It "Should apply to workspace" {
        $policy = New-WorkspacePolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to product" {
        $policy = New-ProductPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to operation" {
        $policy = New-OperationPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        $result | Assert-RuleFailed
    }

    
    It "Should not apply to global" {
        $policy = New-GlobalPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        $result | Assert-RuleSkipped
    }

    
    It "Should not apply to policy fragment" {
        $policy = New-PolicyFragment "<fragment></fragment>"
        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        $result | Assert-RuleSkipped
    }
}