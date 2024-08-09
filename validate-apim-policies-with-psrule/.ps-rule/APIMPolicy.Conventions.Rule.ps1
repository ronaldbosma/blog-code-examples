<#
    This file contains PSRule conventions that can be used load Azure API Management policy files for PSRule analysis.
    Documentation: https://microsoft.github.io/PSRule/v2/concepts/PSRule/en-US/about_PSRule_Conventions/
#>


# Synopsis: Imports the global XML policy file for analysis. File names should match: global.cshtml
Export-PSRuleConvention 'APIMPolicy.Conventions.Global.Import' -Initialize {
    $policies = @(Get-ChildItem -Path '.' -Include 'global.cshtml' -Recurse -File | ForEach-Object {

        # Use the relative path of the file as the object name, this makes it easier to e.g. apply suppressions
        # Example: .\src\global.cshtml
        $name = $_.FullName | Resolve-Path -Relative

        [PSCustomObject]@{
            Name = $name
            Content = [Xml](Get-Content -Path $_.FullName -Raw)
        }

    })

    $PSRule.ImportWithType('APIMPolicy.Types.Global', $policies);
}

# Synopsis: Imports XML policy files of APIs for analysis. File names should end with: .api.cshtml
Export-PSRuleConvention 'APIMPolicy.Conventions.API.Import' -Initialize {
    $policies = @(Get-ChildItem -Path '.' -Include '*.api.cshtml' -Recurse -File | ForEach-Object {

        # Use the relative path of the file as the object name, this makes it easier to e.g. apply suppressions
        # Example: .\src\my.api.cshtml
        $name = $_.FullName | Resolve-Path -Relative

        [PSCustomObject]@{
            Name = $name
            Content = [Xml](Get-Content -Path $_.FullName -Raw)
        }

    })

    $PSRule.ImportWithType('APIMPolicy.Types.API', $policies);
}

# Synopsis: Imports XML policy files of Operations for analysis. File names should end with: .operation.cshtml
Export-PSRuleConvention 'APIMPolicy.Conventions.Operation.Import' -Initialize {
    $policies = @(Get-ChildItem -Path '.' -Include '*.operation.cshtml' -Recurse -File | ForEach-Object {

        # Use the relative path of the file as the object name, this makes it easier to e.g. apply suppressions
        # Example: .\src\my.operation.cshtml
        $name = $_.FullName | Resolve-Path -Relative

        [PSCustomObject]@{
            Name = $name
            Content = [Xml](Get-Content -Path $_.FullName -Raw)
        }

    })

    $PSRule.ImportWithType('APIMPolicy.Types.Operation', $policies);
}