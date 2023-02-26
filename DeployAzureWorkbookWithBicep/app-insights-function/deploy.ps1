$placeholders = @{
    "apimName" = "<api management name>";
}

.\deploy-shared-function.ps1 -SubscriptionId "<subscription id>" `
    -ResourceGroup "<resource group with app insights>" `
    -AppInsightsName "app insights name" `
    -FunctionName "ApimRequests" `
    -FunctionFilePath ".\ApimRequests.kql" `
    -Placeholders $placeholders