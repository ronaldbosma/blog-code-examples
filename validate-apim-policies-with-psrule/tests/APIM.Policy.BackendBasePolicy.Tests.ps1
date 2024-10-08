<#
    Tests for APIM.Policy.BackendBasePolicy rule
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

Describe "APIM.Policy.BackendBasePolicy" {

    It "Should pass if base policy is the only policy in the backend section" {
        $policy = New-APIPolicy @"
            <policies>
                <backend>
                    <base />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"
        
        $result | Assert-RulePassed
    }


    It "Should fail if the base policy is missing from the backend section" {
        $policy = New-APIPolicy @"
            <policies>
                <backend>
                    <not-base />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should fail if the backend section is empty" {
        $policy = New-APIPolicy @"
            <policies>
                <backend />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }


    It "Should fail if there is more than one policy in the backend section" {
        $policy = New-APIPolicy @"
            <policies>
                <backend>
                    <first />
                    <base />
                    <third />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend.ChildNodes.Count*3*"
    }


    It "Should fail if the backend section is missing" {
        $policy = New-APIPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend*not exist*"
    }


    It "Should apply to workspace" {
        $policy = New-WorkspacePolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to product" {
        $policy = New-ProductPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"
        $result | Assert-RuleFailed
    }


    It "Should apply to operation" {
        $policy = New-OperationPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"
        $result | Assert-RuleFailed
    }

    
    It "Should not apply to global" {
        $policy = New-GlobalPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"
        $result | Assert-RuleSkipped
    }

    
    It "Should not apply to policy fragment" {
        $policy = New-PolicyFragment "<fragment></fragment>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendBasePolicy"
        $result | Assert-RuleSkipped
    }
}