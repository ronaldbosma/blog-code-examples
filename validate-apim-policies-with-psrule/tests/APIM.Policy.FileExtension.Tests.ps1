<#
    Tests for APIM.Policy.FileExtension rule
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

Describe "APIM.Policy.FileExtension" {

    It "Should pass if the file name is global.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "global.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RulePassed
    }

    
    It "Should pass if the file name ends with .workspace.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.workspace.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RulePassed
    }


    It "Should pass if the file name ends with .product.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.product.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RulePassed
    }


    It "Should pass if the file name ends with .api.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.api.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RulePassed
    }


    It "Should pass if the file name ends with .operation.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.operation.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RulePassed
    }


    It "Should pass if the file name ends with .fragment.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.fragment.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RulePassed
    }


    It "Should fail if the file name ends with unknown extension" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "unknown.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "Unknown API Management policy scope. Expected file name global.cshtml or name ending with: .workspace.cshtml, .product.cshtml, .api.cshtml, .operation.cshtml, or .fragment.cshtml"
    }


    It "Should be skipped if the file is not a .cshtml file" {
        $file = [PSCustomObject]@{
            PSTypeName = ".txt" # This is necessary for the -Type filter on a Rule to work
            Name = "skip.txt"
        }

        $result = Invoke-CustomPSRule $file "APIM.Policy.FileExtension"
        $result | Assert-RuleSkipped
    }
}