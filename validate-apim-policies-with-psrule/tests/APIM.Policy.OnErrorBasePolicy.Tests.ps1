<#
    Tests for APIM.Policy.OnErrorBasePolicy rule.
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

Describe "APIM.Policy.OnErrorBasePolicy" {

    It "Should return true if base policy is the only policy in the on-error section" {
        $policy = New-APIPolicy @"
            <policies>
                <on-error>
                    <base />
                </on-error>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        
        $result | Assert-RuleSucceeded
    }


    It "Should return true if base policy is any of the policies in the on-error section" {
        $policy = New-APIPolicy @"
            <policies>
                <on-error>
                    <first />
                    <base />
                    <third />
                </on-error>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        $result | Assert-RuleSucceeded
    }


    It "Should return false if the base policy is missing from the on-error section" {
        $policy = New-APIPolicy @"
            <policies>
                <on-error>
                    <not-base />
                </on-error>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should return false if the on-error section is empty" {
        $policy = New-APIPolicy @"
            <policies>
                <on-error />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should return false if the on-error section is missing" {
        $policy = New-APIPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*on-error*not exist*"
    }


    It "Should apply to workspace" {
        $policy = New-WorkspacePolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to product" {
        $policy = New-ProductPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to operation" {
        $policy = New-OperationPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        $result | Assert-RuleFailed
    }

    
    It "Should not apply to global" {
        $policy = New-GlobalPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        $result | Assert-RuleSkipped
    }

    
    It "Should not apply to policy fragment" {
        $policy = New-PolicyFragment "<fragment></fragment>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.OnErrorBasePolicy"
        $result | Assert-RuleSkipped
    }
}