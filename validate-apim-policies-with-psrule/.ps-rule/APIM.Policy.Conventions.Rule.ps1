<#
    This file contains a PSRule convention that can be used to load Azure API Management policy files for PSRule analysis.
    Conventions Documentation: https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Conventions/
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

        # Determine the scope of the policy based on the file name.
        $scope = $null
        if ($policyFile.Name -eq "global.cshtml") { $scope = "Global" }
        elseif ($policyFile.Name.EndsWith(".workspace.cshtml")) { $scope = "Workspace" }
        elseif ($policyFile.Name.EndsWith(".product.cshtml")) { $scope = "Product" }
        elseif ($policyFile.Name.EndsWith(".api.cshtml")) { $scope = "API" }
        elseif ($policyFile.Name.EndsWith(".operation.cshtml")) { $scope = "Operation" }
        elseif ($policyFile.Name.EndsWith(".fragment.cshtml")) { $scope = "Fragment" }

        # Only create a policy object to analyse if the scope is recognized.
        # The 'APIM.Policy.FileExtension' rule will report on unknown file extensions.
        if ($null -ne $scope) {
            try {
                $policies += [PSCustomObject]@{
                    Name = $name
                    Scope = $scope
                    Content = [Xml](Get-Content -Path $policyFile.FullName -Raw)
                }
            }
            catch {
                # Add policy files with invalid XML to a separate list, so we can report them in a separate rule.
                # By adding them as a different type, we don't have to exclude them from every APIM Policy rule that expects valid XML.
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
