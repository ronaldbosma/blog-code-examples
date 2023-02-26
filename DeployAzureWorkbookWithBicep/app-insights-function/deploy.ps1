$subscriptionId = '<subscription id>'
$resourceGroupName = '<resource group>'
$applicationInsightsName = '<application insights id>'
$functionName = "myTestFunction4"


$functions = az rest --method get --url "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$applicationInsightsName/analyticsItems?api-version=2015-05-01"
$function = $functions | ConvertFrom-Json | Where-Object -Property "name" -Value $functionName -EQ

if ($null -ne $function)
{
    Write-Host "Delete $functionName"
    az rest --method "DELETE" --url """https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$applicationInsightsName/analyticsItems/item?api-version=2015-05-01&includeContent=true&scope=shared&type=function&name=$functionName"""
}

$url = "$baseUrl/item/$apiVersion"
Set-Content -Path "./body.json" -Value @"
{
    "scope": "shared",
    "type": "function",
    "name": "$functionName",
    "content": "trace | count",
    "properties": {
        "functionAlias": "$functionName"
    }
}
"@

az rest --method "PUT" --url $url --headers "Content-Type=application/json" --body '@body.json'



$functions = az rest --method get --url "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$applicationInsightsName/analyticsItems?api-version=2015-05-01"
$functions