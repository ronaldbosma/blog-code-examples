<#
    Tests for the APIM.Policy.UseBackendEntity rule.
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

Describe "APIM.Policy.UseBackendEntity" {

    It "Should return true if the backend-id attribute is set on the set-backend-service policy" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <set-backend-service backend-id="test" />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        
        $result | Assert-RuleSucceeded
    }


    It "Should return false if the backend-id attribute is NOT set on the set-backend-service policy" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <set-backend-service base-url="https://test.nl" />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }


    It "Should return false if the backend-id attribute is NOT set on atleast one set-backend-service policy" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <set-backend-service backend-id="test" />
                    <set-backend-service base-url="https://test.nl" />
                    <set-backend-service backend-id="test" />
                    <set-backend-service base-url="https://test.nl" />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }


    It "Should return false if the backend-id attribute is NOT set on a set-backend-service policy, even if it's a nested policy" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <choose>
                        <when condition="true">
                            <set-backend-service base-url="https://test.nl" />
                        </when>
                    </choose>
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }


    It "Should skip rule if no set-backend-service policy is configured" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        
        $result | Assert-RuleSkipped
    }


    It "Should apply to global policy" {
        $policy = New-GlobalPolicy '<policies><inbound><set-backend-service base-url="https://test.nl" /></inbound></policies>'
        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }


    It "Should apply to workspace policy" {
        $policy = New-WorkspacePolicy '<policies><inbound><set-backend-service base-url="https://test.nl" /></inbound></policies>'
        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }


    It "Should apply to product policy" {
        $policy = New-ProductPolicy '<policies><inbound><set-backend-service base-url="https://test.nl" /></inbound></policies>'
        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }


    It "Should apply to operation policy" {
        $policy = New-OperationPolicy '<policies><inbound><set-backend-service base-url="https://test.nl" /></inbound></policies>'
        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }


    It "Should apply to policy fragment" {
        $policy = New-PolicyFragment '<policies><inbound><set-backend-service base-url="https://test.nl" /></inbound></policies>'
        $result = Invoke-CustomPSRule $policy "APIM.Policy.UseBackendEntity"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "*backend-id*not exist*"
    }
}