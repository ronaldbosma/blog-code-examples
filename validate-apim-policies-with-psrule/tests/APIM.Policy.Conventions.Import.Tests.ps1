<#
    Tests for the APIM.Policy.Conventions.Import convention.
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


    # If you execute Invoke-PSRule from inside the test folder, no files will be analysed. So, we go up one level.
    Push-Location "$PSScriptRoot/.."
    try {
        # Note that I tried using https://microsoft.github.io/PSRule/v2/commands/PSRule/en-US/Get-PSRuleTarget/ to get the targets, 
        # but it didn't return the custom objects we created in the convention. So, I'm using the PSRule analysis result instead.
        $result = Invoke-PSRule -InputPath "./src/" -Option "./.ps-rule/ps-rule.yaml"
    }
    finally {
        Pop-Location
    }
}

Describe "APIM.Policy.Conventions.Import" {
    It "should import policy files with valid XML as APIM.Policy" {
        $expectedPolicyFiles = @(
            [PSCustomObject]@{ Name = "./src/bad/bad.api.cshtml"; Scope = "API" },
            [PSCustomObject]@{ Name = "./src/bad/bad.fragment.cshtml"; Scope = "Fragment" },
            [PSCustomObject]@{ Name = "./src/bad/bad.operation.cshtml"; Scope = "Operation" },
            [PSCustomObject]@{ Name = "./src/bad/bad.product.cshtml"; Scope = "Product" },
            [PSCustomObject]@{ Name = "./src/bad/bad.workspace.cshtml"; Scope = "Workspace" },
            [PSCustomObject]@{ Name = "./src/bad/global.cshtml"; Scope = "Global" },
            [PSCustomObject]@{ Name = "./src/good/global.cshtml"; Scope = "Global" },
            [PSCustomObject]@{ Name = "./src/good/good.api.cshtml"; Scope = "API" },
            [PSCustomObject]@{ Name = "./src/good/good.fragment.cshtml"; Scope = "Fragment" },
            [PSCustomObject]@{ Name = "./src/good/good.operation.cshtml"; Scope = "Operation" },
            [PSCustomObject]@{ Name = "./src/good/good.product.cshtml"; Scope = "Product" },
            [PSCustomObject]@{ Name = "./src/good/good.workspace.cshtml"; Scope = "Workspace" }
        )

        # Get the actual policy files based on the PSRule result. 
        # The TargetObject holds the custom object we created in the convention.
        # Because multiple rules can be applied to the same target, we need to get the unique policy files.
        $actualPolicyFiles = $result | Where-Object { $_.TargetType -eq "APIM.Policy" } | Select-Object -ExpandProperty TargetObject | Get-Unique -AsString

        # Assert that the correct number of policy files were found
        $actualPolicyFiles.Length | Should -Be $expectedPolicyFiles.Length
        
        foreach ($expectedPolicyFile in $expectedPolicyFiles) {
            # Find the actual policy file with the same name
            $actualPolicyFile = $actualPolicyFiles | Where-Object { $_.Name -eq $expectedPolicyFile.Name }

            # Assert that the policy file exists and that it has the correct data
            $actualPolicyFile | Should -Not -BeNullOrEmpty -Because "a policy file with name '$($expectedPolicyFile.Name)' should exist"
            $actualPolicyFile.Scope | Should -Be $expectedPolicyFile.Scope -Because "the scope of the policy file '$($expectedPolicyFile.Name)' should be '$($expectedPolicyFile.Scope)'"
            $actualPolicyFile.Content | Should -BeOfType [xml] -Because "the content of the policy file '$($expectedPolicyFile.Name)' should be of type 'xml'"
        }
    }
    
    It "should import policy files with invalid XML as APIM.PolicyWithInvalidXml" {
        $expectedPolicyFiles = @(
            "./src/bad/invalid-xml-1.operation.cshtml"
            "./src/bad/invalid-xml-2.operation.cshtml"
        )

        # Get the actual policy files based on the PSRule result. 
        # The TargetObject holds the custom object we created in the convention.
        # Because multiple rules can be applied to the same target, we need to get the unique policy files.
        $actualPolicyFiles = $result | Where-Object { $_.TargetType -eq "APIM.PolicyWithInvalidXml" } | Select-Object -ExpandProperty TargetObject | Get-Unique -AsString

        # Assert that the correct number of policy files with invalid XML were found
        $actualPolicyFiles.Length | Should -Be $expectedPolicyFiles.Length
        
        foreach ($expectedPolicyFile in $expectedPolicyFiles) {
            # Find the actual policy file with the same name
            $actualPolicyFile = $actualPolicyFiles | Where-Object { $_.Name -eq $expectedPolicyFile }

            # Assert that the policy file exists and that it has an error message set
            $actualPolicyFile | Should -Not -BeNullOrEmpty -Because "a policy file with name '$expectedPolicyFile' should exist"
            $actualPolicyFile.Error | Should -Not -BeNullOrEmpty -Because "the policy file '$expectedPolicyFile' should have an error message"
        }
    }
}