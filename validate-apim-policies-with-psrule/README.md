# Validate APIM Policies with PSRule

## Execute PSRule on APIM Policy rules

The `.ps-rule` folder contains custom [PSRule](https://microsoft.github.io/PSRule) conventions and rules, which can be used to validate Azure API Management (APIM) policies through static analysis. The `src` folder contains a couple of sample policy files that can be used to test the custom rules. 

Execute the following command to check the policies in the `src` folder against the custom APIM Policy rules:

```powershell
Invoke-PSRule -InputPath ".\src\" -Option ".\.ps-rule\ps-rule.yaml"
```

## Execute tests

The `test` folder contains [Pester](https://pester.dev/) tests for each custom rule. 
To execute the tests, open a PowerShell terminal, navigate to the `tests` folder and execute the following command:

```powershell
.\Invoke-PesterTests.ps1 -ModulePath .
```

You can filter the test files using the `-IncludeTestFiles` parameter. For example, to test only the rules that are in files with `UseBackend` in the name, execute the following command:

```powershell
.\Invoke-PesterTests.ps1 -ModulePath . -IncludeTestFiles "*UseBackend*"
```