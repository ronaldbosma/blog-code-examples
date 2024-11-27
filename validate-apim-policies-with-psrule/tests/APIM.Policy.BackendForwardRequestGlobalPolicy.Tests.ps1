<#
    Tests for APIM.Policy.BackendForwardRequestGlobalPolicy rule
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

Describe "APIM.Policy.BackendForwardRequestGlobalPolicy" {

    It "Should pass if forward-request policy is the only policy in the backend section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend>
                    <forward-request />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendForwardRequestGlobalPolicy"
        
        $result | Assert-RulePassed
    }


    It "Should fail if the forward-request policy is missing from the backend section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend>
                    <not-forward-request />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendForwardRequestGlobalPolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*forward-request*not exist*"
    }


    It "Should fail if the backend section is empty" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendForwardRequestGlobalPolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*forward-request*not exist*"
    }


    It "Should fail if there is more than one policy in the backend section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend>
                    <first />
                    <forward-request />
                    <third />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendForwardRequestGlobalPolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend.ChildNodes.Count*3*"
    }


    It "Should fail if the backend section is missing" {
        $policy = New-GlobalPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIM.Policy.BackendForwardRequestGlobalPolicy"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend*not exist*"
    }
}