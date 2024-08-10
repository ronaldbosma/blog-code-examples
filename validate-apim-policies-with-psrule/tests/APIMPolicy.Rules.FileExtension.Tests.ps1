<#
    Tests for APIMPolicy.Rules.FileExtension rule
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

Describe "APIMPolicy.Rules.FileExtension" {

    It "Should return true if the file name is global.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "global.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleSucceeded
    }

    
    It "Should return true if the file name ends with .workspace.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.workspace.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleSucceeded
    }


    It "Should return true if the file name ends with .product.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.product.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleSucceeded
    }


    It "Should return true if the file name ends with .api.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.api.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleSucceeded
    }


    It "Should return true if the file name ends with .operation.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.operation.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleSucceeded
    }


    It "Should return true if the file name ends with .fragment.cshtml" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "test.fragment.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleSucceeded
    }


    It "Should return false if the file name ends with unknown extension" {
        $file = [PSCustomObject]@{
            PSTypeName = ".cshtml" # This is necessary for the -Type filter on a Rule to work
            Name = "unknown.cshtml"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleFailedWithReason -ExpectedReasonPattern "Unknown file extension, expected: global.cshtml, .workspace.cshtml, .product.cshtml, .api.cshtml, .operation.cshtml, or .fragment.cshtml"
    }


    It "Should be skipped if the file is not a .cshtml file" {
        $file = [PSCustomObject]@{
            PSTypeName = ".txt" # This is necessary for the -Type filter on a Rule to work
            Name = "skip.txt"
        }

        $result = Invoke-CustomPSRule $file "APIMPolicy.Rules.FileExtension"
        $result | Assert-RuleSkipped
    }
}