<#
    Tests for the APIM.Policy.RemoveSubscriptionKeyHeader rule.
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

Describe "APIM.Policy.RemoveSubscriptionKeyHeader" {

    It "Should return true if the subscription key header is removed in the inbound section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <inbound>
                    <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.RemoveSubscriptionKeyHeader"
        
        $result | Assert-RuleSucceeded
    }


    It "Should return false if the subscription key header is NOT removed in the inbound section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <inbound />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.RemoveSubscriptionKeyHeader"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "Unable to find a set-header policy that removes the Ocp-Apim-Subscription-Key header as a direct child of the inbound section."
    }


    It "Should return false if a set-header policy with delete action is present in the inbound section, but for a different header" {
        $policy = New-GlobalPolicy @"
            <policies>
                <inbound>
                    <set-header name="Authorization" exists-action="delete" />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.RemoveSubscriptionKeyHeader"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "Unable to find a set-header policy that removes the Ocp-Apim-Subscription-Key header as a direct child of the inbound section."
    }


    It "Should return false if a set-header policy is present for the subscription key, but the action is not delete" {
        $policy = New-GlobalPolicy @"
            <policies>
                <inbound>
                    <set-header name="Ocp-Apim-Subscription-Key" exists-action="skip" />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.RemoveSubscriptionKeyHeader"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "Unable to find a set-header policy that removes the Ocp-Apim-Subscription-Key header as a direct child of the inbound section."
    }


    It "Should return false if a set-header policy to remove the subscription key exists, but is not a direct child of the inbound section" {
        $policy = New-GlobalPolicy @"
            <policies>
                <inbound>
                    <choose>
                        <when condition="True">
                            <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
                        </when>
                    </choose>
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.RemoveSubscriptionKeyHeader"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "Unable to find a set-header policy that removes the Ocp-Apim-Subscription-Key header as a direct child of the inbound section."
    }
}