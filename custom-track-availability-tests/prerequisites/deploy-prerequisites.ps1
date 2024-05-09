param (
    [string]$Workload = 'customavail',
    [string]$Environment = 'dev',
    [string]$Location = 'norwayeast',
    [string]$Instance = '01',
    [string]$ResourceGroupName = $null,
    [string]$KeyVaultAdministratorId = $null
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


# =============================================================================
#  Create Resource Group
# =============================================================================

if (-not($ResourceGroupName)) {
    $ResourceGroupName = "rg-$WorkloadName-$Environment-$Location-$Instance".ToLower()
}

# Create the resource group if it doesn't exist
if ((az group exists --name $ResourceGroupName) -eq "false")
{
    Write-Host "Create resource group: $ResourceGroupName"
    az group create --name $ResourceGroupName --location $Location
}


# =============================================================================
#  Get Settings from Signed-In User
# =============================================================================

# If the Id of the Key Vault Administrators is not specified, try to get the signed in user and use theirs.
# NOTE: depending on the access rights of the signed in user, this might fail.
if (-not($KeyVaultAdministratorId))
{
    $signedInUser = az ad signed-in-user show | ConvertFrom-Json
    if (-not($KeyVaultAdministratorId))
    {
        $KeyVaultAdministratorId = $signedInUser.id
    }
}


# =============================================================================
#  Validate Deployment
# =============================================================================

# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Start deployment validation at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Validate the deployment of the resources with Bicep
az deployment group validate `
    --name "validate-custom-track-availability-tests-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './prerequisites.bicep' `
    --parameters workload=$Workload `
                 environment=$Environment `
                 instance=$Instance `
                 keyVaultAdministratorId=$KeyVaultAdministratorId `
    --verbose


# =============================================================================
#  Deployment Resources
# =============================================================================
    
# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Start deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Deploy the resources with Bicep
az deployment group create `
    --name "deploy-custom-track-availability-tests-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './prerequisites.bicep' `
    --parameters workload=$Workload `
                 environment=$Environment `
                 instance=$Instance `
                 keyVaultAdministratorId=$KeyVaultAdministratorId `
    --verbose