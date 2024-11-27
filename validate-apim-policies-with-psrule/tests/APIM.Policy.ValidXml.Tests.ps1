<#
    Tests for APIM.Policy.ValidXml rule
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

Describe "APIM.Policy.ValidXml" {
    It "Should succeed for objects of type APIM.Policy" {
        $input = [PSCustomObject]@{
            PSTypeName = "APIM.Policy" # This is necessary for the -Type filter on a Rule to work
            Name = "valid-xml.api.cshtml"
        }

        $result = Invoke-CustomPSRule $input "APIM.Policy.ValidXml"
        $result | Assert-RulePassed
    }


    It "Should fail for objects of type APIM.PolicyWithInvalidXml" {
        $input = [PSCustomObject]@{
            PSTypeName = "APIM.PolicyWithInvalidXml" # This is necessary for the -Type filter on a Rule to work
            Name = "invalid-xml.api.cshtml"
            Error = "This error message"
        }

        $result = Invoke-CustomPSRule $input "APIM.Policy.ValidXml"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "This error message"
    }
}