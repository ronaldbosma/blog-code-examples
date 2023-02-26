$resourceGroupName = '<resource group>'
$applicationInsightsId = '<application insights id>'

az deployment group create `
    --name 'sample-workbook-deployment' `
    --resource-group $resourceGroupName `
    --template-file './sample-arm-template.bicep' `
    --parameters `
        workbookDisplayName='Sample Deployed Workbook (Based on ARM template)' `
        workbookSourceId=$applicationInsightsId `
    --verbose