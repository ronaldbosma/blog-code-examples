<#
    This file contains PSRule conventions that can be used load Azure API Management policy files for PSRule analysis.
    Documentation: https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Conventions/
#>


# Synopsis: Imports the APIM XML policy file for analysis. File names should match: *.cshtml
Export-PSRuleConvention 'APIM.Policy.Conventions.Import' -Initialize {
    $policies = @(Get-ChildItem -Path '.' -Include '*.cshtml' -Recurse -File | ForEach-Object {

        # Use the relative path of the file as the object name, this makes it easier to e.g. apply suppressions.
        # Also replace backslashes with forward slashes, so the path doesn't differ between Windows and Linux.
        # Example: ./src/my.api.cshtml
        $name = ($_.FullName | Resolve-Path -Relative).Replace('\', '/')

        # Determine the level of the policy based on the file name
        $level = "Unknown"
        if ($_.Name -eq "global.cshtml") { $level = "Global" }
        elseif ($_.Name.EndsWith(".workspace.cshtml")) { $level = "Workspace" }
        elseif ($_.Name.EndsWith(".product.cshtml")) { $level = "Product" }
        elseif ($_.Name.EndsWith(".api.cshtml")) { $level = "API" }
        elseif ($_.Name.EndsWith(".operation.cshtml")) { $level = "Operation" }
        elseif ($_.Name.EndsWith(".fragment.cshtml")) { $level = "Fragment" }

        # Only create an object to analyse if the level is known
        if ($level -ne "Unknown") {
            [PSCustomObject]@{
                Name = $name
                Level = $level
                Content = [Xml](Get-Content -Path $_.FullName -Raw)
            }
        }
    })

    $PSRule.ImportWithType('APIM.Policy', $policies);
}
