$resourceGroupName = '<resource group>'
$applicationInsightsName = '<application insights name>'

az deployment group create `
    --name 'sample-workbook-deployment' `
    --resource-group $resourceGroupName `
    --template-file './sample.bicep' `
    --parameters appInsightsName=$applicationInsightsName `
    --verbose