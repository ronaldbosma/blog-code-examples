$subscriptionId = '<subscription id>'
$resourceGroupName = '<resource group>'
$applicationInsightsName = '<application insights id>'
$functionName = "ApimRequests"


$functions = az rest --method get --url "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$applicationInsightsName/analyticsItems?api-version=2015-05-01"
$function = $functions | ConvertFrom-Json | Where-Object -Property "name" -Value $functionName -EQ

if ($null -ne $function)
{
    Write-Host "Delete $functionName function"
    az rest --method "DELETE" --url """https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$applicationInsightsName/analyticsItems/item?api-version=2015-05-01&includeContent=true&scope=shared&type=function&name=$functionName"""
}


Write-Host "Add $functionName function"

$url = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$applicationInsightsName/analyticsItems/item?api-version=2015-05-01"
Set-Content -Path "./body.json" -Value @"
{
    "scope": "shared",
    "type": "function",
    "name": "$functionName",
    "content": "requests",
    "properties": {
        "functionAlias": "$functionName"
    }
}
"@

az rest --method "PUT" --url $url --headers "Content-Type=application/json" --body '@body.json'