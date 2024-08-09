BeforeAll {
    # Setup error handling
    $ErrorActionPreference = 'Stop';
    Set-StrictMode -Version latest;

    if ($Env:SYSTEM_DEBUG -eq 'true') {
        $VerbosePreference = 'Continue';
    }

    # Load functions
    . ./Functions.ps1
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
        
        $result | Assert-PSRuleSucceeded
    }

    It "Should return true if base policy is the first policy in the inbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <base />
                    <second />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        
        $result | Assert-PSRuleSucceeded
    }

    It "Should return false if base policy is NOT the first policy in the inbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <first />
                    <base />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        
        $result | Assert-PSRuleFailedWithReason -ExpectedReasonPattern "*inbound.FirstChild.Name*first*"
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

        $result | Assert-PSRuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }

    It "Should return false if the inbound section is empty" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"

        $result | Assert-PSRuleFailedWithReason -ExpectedReasonPattern "*base*not exist*"
    }

    It "Should return false if the inbound section is missing" {
        $policy = New-APIPolicy @"
            <policies>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"

        $result | Assert-PSRuleFailedWithReason -ExpectedReasonPattern "*inbound*not exist*"
    }
}