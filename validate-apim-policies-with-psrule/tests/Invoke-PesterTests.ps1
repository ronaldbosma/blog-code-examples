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

function Install-RequiredModule([string]$Name, [string]$Version, [string]$MinimumVersion)
{
    $module = Get-Module -Name $Name -ListAvailable | Where-Object {$_.Version -like $Version}
    if (!$module) { 
        try {
            Install-Module -Name $Name -Repository PSGallery -Scope CurrentUser -Force -SkipPublisherCheck -MinimumVersion $MinimumVersion
            $module = Get-Module -Name $Name -ListAvailable | Where-Object {$_.Version -like $Version}
        }
        catch {
            Write-Error "Failed to install the $Name module."
        }
    }

    Write-Host "$Name version: $($module.Version)"
}

Install-RequiredModule -Name "PSRule" -Version "2.*" -MinimumVersion "2.9.0"
Install-RequiredModule -Name "Pester" -Version "5.*" -MinimumVersion "5.0"


$config = New-PesterConfiguration
$config.Run.Path = $Path

# Enable test result generation if the TestResultsPath parameter is provided
if (-not([string]::IsNullOrWhiteSpace($TestResultsPath))) {
    $config.TestResult.OutputFormat = "NUnitXml"
    $config.TestResult.OutputPath = $TestResultsPath
    $config.TestResult.Enabled = $True
}

Invoke-Pester -Configuration $config