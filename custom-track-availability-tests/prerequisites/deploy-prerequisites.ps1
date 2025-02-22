param (
    [Parameter(Mandatory)][ValidateLength(5,12)][string]$Workload, # To prevent errors, we keep it short
    [string]$Environment = "dev",
    [string]$Location = "norwayeast",
    [string]$Instance = "01",
    [string]$CurrentUserPrincipalId = $null
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest


# =============================================================================
#  Get Settings from Signed-In User
# =============================================================================

# If the Id of the Current User is not specified, try to get the signed in user and use theirs.
# NOTE: depending on the access rights of the signed in user, this might fail.
if (-not($CurrentUserPrincipalId))
{
    $signedInUser = az ad signed-in-user show | ConvertFrom-Json
    if (-not($CurrentUserPrincipalId))
    {
        $CurrentUserPrincipalId = $signedInUser.id
    }
}


# =============================================================================
#  Validate Deployment
# =============================================================================

# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Validate deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Validate the deployment of the resources with Bicep
az deployment sub validate `
    --name "validate-$Workload-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --location $Location `
    --template-file './prerequisites.bicep' `
    --parameters location=$Location `
                 workload=$Workload `
                 environment=$Environment `
                 instance=$Instance `
                 currentUserPrincipalId=$CurrentUserPrincipalId `
    --verbose


# =============================================================================
#  Deploy Resources
# =============================================================================
    
# Print the time and date before starting the deployment so you can estimate when it's finished if you have an expected duration
Write-Host "Start deployment at: $(Get-Date -Format "dd-MM-yyyy HH:mm:ss")"

# Deploy the resources with Bicep
az deployment sub create `
    --name "deploy-$Workload-$(Get-Date -Format "yyyyMMdd-HHmmss")" `
    --location $Location `
    --template-file './prerequisites.bicep' `
    --parameters location=$Location `
                 workload=$Workload `
                 environment=$Environment `
                 instance=$Instance `
                 currentUserPrincipalId=$CurrentUserPrincipalId `
    --verbose
