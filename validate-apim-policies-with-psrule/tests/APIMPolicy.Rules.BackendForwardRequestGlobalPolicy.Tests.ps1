<#
    Tests for APIMPolicy.Rules.BackendForwardRequestGlobalPolicy rule
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

Describe "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy" {

    It "Should return true if forward-request policy is the only policy in the backend section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend>
                    <forward-request />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy"
        
        $result | Assert-RuleSucceeded
    }


    It "Should return false if the forward-request policy is missing from the backend section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend>
                    <not-forward-request />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*forward-request*not exist*"
    }


    It "Should return false if the backend section is empty" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*forward-request*not exist*"
    }


    It "Should return false if there is more than one policy in the backend section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <backend>
                    <first />
                    <forward-request />
                    <third />
                </backend>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy"

        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend.ChildNodes.Count*3*"
    }


    It "Should return false if the backend section is missing" {
        $policy = New-GlobalPolicy "<policies></policies>"
        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.BackendForwardRequestGlobalPolicy"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend*not exist*"
    }
}