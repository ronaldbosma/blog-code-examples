[CmdletBinding()]
param(
    # Azure Subscription Id
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,

    # Name of the resource group of the Application Insights resource
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    # Name of the Application Insights resource
    [Parameter(Mandatory=$true)]
    [string]$AppInsightsName,

    # Name of the function
    [Parameter(Mandatory=$true)]
    [string]$FunctionName,

    # Path to the file containing the function content
    [Parameter(Mandatory=$true)]
    [string]$FunctionFilePath,

    # Hashtable of placeholders that should be replaced in the function content
    [Parameter()]
    [hashtable]$Placeholders
)


# Load the function content
Write-Host "Load $FunctionFilePath"
$content = Get-Content -Path $FunctionFilePath
$content = $content -Replace """", "\"""  # Escape " in the query
foreach ($key in $Placeholders.Keys)
{
    $content = $content -Replace "##$key##", $Placeholders[$key]
}


# Retrieve existing functions
$functions = az rest --method get --url "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/components/$AppInsightsName/analyticsItems?api-version=2015-05-01"
$function = $functions | ConvertFrom-Json | Where-Object -Property "name" -Value $FunctionName -EQ

# Delete existing function if found
if ($null -ne $function)
{
    Write-Host "Delete $FunctionName function"
    az rest --method "DELETE" --url """https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/components/$AppInsightsName/analyticsItems/item?api-version=2015-05-01&includeContent=true&scope=shared&type=function&name=$FunctionName"""
}


# Create a request body file in the temp folder
# This will be used to create the function
$requestBodyPath = Join-Path $env:TEMP "create-shared-function-request-body.json"
Set-Content -Path $requestBodyPath -Value @"
{
    "scope": "shared",
    "type": "function",
    "name": "$FunctionName",
    "content": "$content",
    "properties": {
        "functionAlias": "$FunctionName"
    }
}
"@

# Create the function
Write-Host "Add $FunctionName function"
az rest --method "PUT" --url "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/components/$AppInsightsName/analyticsItems/item?api-version=2015-05-01" --headers "Content-Type=application/json" --body "@$requestBodyPath"