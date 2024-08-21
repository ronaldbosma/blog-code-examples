<#
    Script to execute Pester tests.
    Source: https://www.logitblog.com/increase-the-success-rate-of-azure-devops-pipelines-using-pester/
#>

param (
    # Path to the folder containing the Pester test files. Will search recursively for files with the pattern "*Tests.ps1".
    [string]
    $Path = ".",

    # Filter to include only specific test files. For example: "*InboundBasePolicy*"
    [string]
    $IncludeTestFiles = "*",

    # Will enable test and code coverage results to be published
    [Parameter(Mandatory = $false)]
    [switch]
    $Publish,

    # Path where the test and code coverage results will be published
    [Parameter(Mandatory=$false)]
    [string]
    $ResultsPath
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

# Create results path directory if results should be published and the path does not exist
if ($Publish) {
    if (!(Test-Path -Path $ResultsPath)) {
        New-Item -Path $ResultsPath -ItemType Directory -Force | Out-Null
    }
}

# Search for test files
$tests = (Get-ChildItem -Path $($ModulePath) -Include $IncludeTestFiles -Recurse | Where-Object {$_.Name -like "*.Tests.ps1"}).FullName

# Execute Pester tests
if ($Publish) {
    $files = (Get-ChildItem -Recurse | Where-Object {$_.Name -like "*.psm1" -or $_.Name -like "*.ps1" -and $_.FullName -notlike "*\Pipelines\*"}).FullName
    Invoke-Pester $tests -OutputFile "$ResultsPath\Test-Pester.xml" -OutputFormat NUnitXml -CodeCoverage $($files.FullName) -CodeCoverageOutputFile "$($ResultsPath)\Pester-Coverage.xml" -CodeCoverageOutputFileFormat JaCoCo
} else {
    Invoke-Pester $tests
}