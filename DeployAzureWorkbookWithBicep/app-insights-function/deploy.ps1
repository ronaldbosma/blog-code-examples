$subscriptionId = '<subscription id>'
$resourceGroupName = '<resource group>'
$applicationInsightsName = '<application insights id>'
$functionName = "myTestFunction3"


$baseUrl = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Insights/components/$applicationInsightsName/analyticsItems"
$apiVersion = "?api-version=2015-05-01"


$functions = (az rest --method "GET" --url "$baseUrl$apiVersion") | ConvertFrom-Json
$function = $functions | Where-Object -Property "name" -Value $functionName -EQ

if ($null -ne $function)
{
    Write-Host "Delete $functionName"
    az rest --method "DELETE" --url "$baseUrl/item$apiVersion&includeContent=true&scope=shared&type=function&name=$functionName"
}


$url = "$baseUrl/item/$apiVersion"
Set-Content -Path "./body.json" -Value @"
{
    "scope": "shared",
    "type": "function",
    "name": "$functionName",
    "content": "requests | count",
    "properties": {
        "functionAlias": "$functionName"
    }
}
"@

az rest --method "PUT" --url $url --headers "Content-Type=application/json" --body '@body.json'
