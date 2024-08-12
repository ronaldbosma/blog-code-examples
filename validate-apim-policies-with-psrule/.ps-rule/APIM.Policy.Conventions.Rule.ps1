<#
    This file contains PSRule conventions that can be used load Azure API Management policy files for PSRule analysis.
    Documentation: https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Conventions/
#>


# Synopsis: Imports the APIM XML policy file for analysis. File names should match: *.cshtml
Export-PSRuleConvention "APIM.Policy.Conventions.Import" -Initialize {

    $policies = @()
    $policyFilesWithInvalidXml = @()

    $policyFiles = Get-ChildItem -Path "." -Include "*.cshtml" -Recurse -File

    foreach ($policyFile in $policyFiles) {
        # Use the relative path of the file as the object name, this makes it easier to e.g. apply suppressions.
        # Also replace backslashes with forward slashes, so the path doesn't differ between Windows and Linux.
        # Example: ./src/my.api.cshtml
        $name = ($policyFile.FullName | Resolve-Path -Relative).Replace('\', '/')

        # Determine the level of the policy based on the file name
        $level = $null
        if ($policyFile.Name -eq "global.cshtml") { $level = "Global" }
        elseif ($policyFile.Name.EndsWith(".workspace.cshtml")) { $level = "Workspace" }
        elseif ($policyFile.Name.EndsWith(".product.cshtml")) { $level = "Product" }
        elseif ($policyFile.Name.EndsWith(".api.cshtml")) { $level = "API" }
        elseif ($policyFile.Name.EndsWith(".operation.cshtml")) { $level = "Operation" }
        elseif ($policyFile.Name.EndsWith(".fragment.cshtml")) { $level = "Fragment" }

        # Only create a policy object to analyse if the level is known
        if ($null -ne $level) {
            try {
                $policies += [PSCustomObject]@{
                    Name = $name
                    Level = $level
                    Content = [Xml](Get-Content -Path $policyFile.FullName -Raw)
                }
            }
            catch {
                # Add policy files with invalid XML to a separate list, so we can report in a separate rule.
                # By adding them as a different type, we don't have to exclude them from every APIM Policy rule that expectes valid XML.
                $policyFilesWithInvalidXml += [PSCustomObject]@{
                    Name = $name
                    Error = $_.Exception.Message
                }
            }
        }
    }

    $PSRule.ImportWithType("APIM.Policy", $policies);
    $PSRule.ImportWithType("APIM.PolicyWithInvalidXml", $policyFilesWithInvalidXml);
}
