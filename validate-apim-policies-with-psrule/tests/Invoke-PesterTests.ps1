<#
    Script to execute Pester tests.
    Based on: https://www.logitblog.com/increase-the-success-rate-of-azure-devops-pipelines-using-pester/
#>

param (
    # Path to the folder containing the Pester test files. Default is the current folder.
    [string]
    $Path = ".",

    # Path where the test results will be published. Default is not to publish test results.
    [Parameter(Mandatory=$false)]
    [string]
    $TestResultsPath
)

# Install the Pester PowerShell module if it is not available
$pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
if (!$pesterModule) { 
    try {
        Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck -MinimumVersion "5.0"
        $pesterModule = Get-Module -Name Pester -ListAvailable | Where-Object {$_.Version -like '5.*'}
    }
    catch {
        Write-Error "Failed to install the Pester module."
    }
}

# Import the Pester module
Write-Host "Pester version: $($pesterModule.Version.Major).$($pesterModule.Version.Minor).$($pesterModule.Version.Build)"
$pesterModule | Import-Module


$config = New-PesterConfiguration
$config.Run.Path = $Path

# Enable test result generation if the TestResultsPath parameter is provided
if (-not([string]::IsNullOrWhiteSpace($TestResultsPath))) {
    $config.TestResult.OutputFormat = "NUnitXml"
    $config.TestResult.OutputPath = TestResultsPath
    $config.TestResult.Enabled = $True
}

Invoke-Pester -Configuration $config