$resourceGroupName = '<resource group>'
$applicationInsightsId = '<application insights id>'

az deployment group create `
    --name 'sample-workbook-deployment' `
    --resource-group $resourceGroupName `
    --template-file './sample.bicep' `
    --parameters workbookSourceId=$applicationInsightsId `
    --verbose