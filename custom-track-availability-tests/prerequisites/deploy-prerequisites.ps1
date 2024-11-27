param (
    [Parameter(Mandatory)][ValidateLength(5,12)][string]$Workload, # To prevent errors, we keep it short
    [string]$Environment = "dev",
    [string]$Location = "norwayeast",
    [string]$Instance = "01",
    [string]$ResourceGroupName = $null,
    [string]$KeyVaultAdministratorId = $null
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


# =============================================================================
#  Create Resource Group
# =============================================================================

if (-not($ResourceGroupName)) {
    # This might not follow the naming convention used in the Bicep script to the letter, but it's close enough
    $ResourceGroupName = "rg-$Workload-$Environment-$Location-$Instance".ToLower()
}

Write-Host "Create resource group '$ResourceGroupName' if it does not exist"
az group create --name $ResourceGroupName --location $Location


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
Write-Host "Validate deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Validate the deployment of the resources with Bicep
az deployment group validate `
    --name "validate-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './prerequisites.bicep' `
    --parameters workload=$Workload `
                 environment=$Environment `
                 instance=$Instance `
                 keyVaultAdministratorId=$KeyVaultAdministratorId `
    --verbose


# =============================================================================
#  Deploy Resources
# =============================================================================
    
# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Start deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Deploy the resources with Bicep
az deployment group create `
--name "deploy-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --resource-group $ResourceGroupName `
    --template-file './prerequisites.bicep' `
    --parameters workload=$Workload `
                 environment=$Environment `
                 instance=$Instance `
                 keyVaultAdministratorId=$KeyVaultAdministratorId `
    --verbose
