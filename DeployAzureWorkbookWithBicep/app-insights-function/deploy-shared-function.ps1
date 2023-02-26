[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$AppInsightsName,

    [Parameter(Mandatory=$true)]
    [string]$FunctionName,

    [Parameter(Mandatory=$true)]
    [string]$FunctionFilePath,

    [Parameter()]
    [hashtable]$Placeholders
)

$functions = az rest --method get --url "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/components/$AppInsightsName/analyticsItems?api-version=2015-05-01"
$function = $functions | ConvertFrom-Json | Where-Object -Property "name" -Value $FunctionName -EQ

if ($null -ne $function)
{
    Write-Host "Delete $FunctionName function"
    az rest --method "DELETE" --url """https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/components/$AppInsightsName/analyticsItems/item?api-version=2015-05-01&includeContent=true&scope=shared&type=function&name=$FunctionName"""
}

Write-Host "Load $FunctionFilePath"
$content = Get-Content -Path $FunctionFilePath
$content = $content -Replace """", "\"""  # Escape " in the query

foreach ($key in $Placeholders.Keys)
{
    $content = $content -Replace "##$key##", $Placeholders[$key]
}

Set-Content -Path "./body.local.json" -Value @"
{
    "id": "bf1d67fa-d92d-4714-aa95-74b0dd2c9a0a",
    "scope": "shared",
    "type": "function",
    "name": "$FunctionName",
    "content": "$content",
    "properties": {
        "functionAlias": "$FunctionName"
    }
}
"@

Write-Host "Add $FunctionName function"
az rest --method "PUT" --url "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Insights/components/$AppInsightsName/analyticsItems/item?api-version=2015-05-01" --headers "Content-Type=application/json" --body '@body.local.json'