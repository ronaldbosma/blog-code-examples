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

    It "Should return true if base policy is the first policy in the inbound section" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound>
                    <base />
                </inbound>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"
        
        $result.IsSuccess() | Should -Be $True
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
        
        $result.IsSuccess() | Should -Be $False
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

        $result.IsSuccess() | Should -Be $False
        $result.Reason.Length | Should -Be 1
        $result.Reason[0] | Should -BeLike "*base*not exist*"
    }

    It "Should return false if inbound section is empty" {
        $policy = New-APIPolicy @"
            <policies>
                <inbound />
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"

        $result.IsSuccess() | Should -Be $False
        $result.Reason.Length | Should -Be 1
        $result.Reason[0] | Should -BeLike "*base*not exist*"
    }

    It "Should return false if the inbound section is missing" {
        $policy = New-APIPolicy @"
            <policies>
            </policies>
"@

        $result = Invoke-CustomPSRule $policy "APIMPolicy.Rules.InboundBasePolicy"

        $result.IsSuccess() | Should -Be $False
        $result.Reason.Length | Should -BeGreaterOrEqual 1
        $result.Reason[0] | Should -BeLike "*inbound*not exist*"
    }
}