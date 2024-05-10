//=============================================================================
// Tests for the getResourceName function
// 
// - Run the tests with the command:  bicep test .\tests.bicep
//=============================================================================

//=============================================================================
// Prefixes
//=============================================================================

test testPrefixVirtualNetwork 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-dev-nwe-001'
  }
}

test testPrefixResourceGroup 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'resourceGroup'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'rg-sample-dev-nwe-001'
  }
}

test testPrefixApiManagement 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'apiManagement'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'apim-sample-dev-nwe-001'
  }
}

test testPrefixFunctionApp 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'functionApp'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'func-sample-dev-nwe-001'
  }
}


//=============================================================================
// Workloads
//=============================================================================

test testWorkloadWithDashes 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample-workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-workload-dev-nwe-001'
  }
}


//=============================================================================
// Locations
//=============================================================================

test testLocationWestEurope 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'dev'
    region: 'westeurope'
    instance: '001'
    expectedResult: 'vnet-sample-dev-we-001'
  }
}

test testLocationNorthEurope 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'dev'
    region: 'northeurope'
    instance: '001'
    expectedResult: 'vnet-sample-dev-ne-001'
  }
}

test testLocationWestCentralUS 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'dev'
    region: 'westcentralus'
    instance: '001'
    expectedResult: 'vnet-sample-dev-wcus-001'
  }
}


//=============================================================================
// Environments
//=============================================================================

test testEnvironmentDevelopment 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'development'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-dev-nwe-001'
  }
}

test testEnvironmentDevelopmentWithUpperCasing 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'Development'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-dev-nwe-001'
  }
}

test testEnvironmentTst 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'tst'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-tst-nwe-001'
  }
}

test testEnvironmentTest 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'test'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-tst-nwe-001'
  }
}

test testEnvironmentAcc 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'acc'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-acc-nwe-001'
  }
}

test testEnvironmentAcceptance 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'acceptance'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-acc-nwe-001'
  }
}

test testEnvironmentPrd 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'prd'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-prd-nwe-001'
  }
}

test testEnvironmentProd 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'prod'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-prd-nwe-001'
  }
}

test testEnvironmentProduction 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'production'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vnet-sample-prd-nwe-001'
  }
}


//=============================================================================
// Instances
//=============================================================================

test testInstance01 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '01'
    expectedResult: 'vnet-sample-dev-nwe-01'
  }
}

test testInstanceMain 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: 'main'
    expectedResult: 'vnet-sample-dev-nwe-main'
  }
}

test testInstancePrimary 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: 'primary'
    expectedResult: 'vnet-sample-dev-nwe-primary'
  }
}


//=============================================================================
// Shortened Names
//=============================================================================

test testShortenedStorageAccountName 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'storageAccount'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'stsampledevnwe001'
  }
}

test testShortenedKeyVaultName 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'keyVault'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'kvsampledevnwe001'
  }
}


//=============================================================================
// Shortened Names - Virtual Machines
//
// The max length of a Windows VM is 15 characters, 
// so we use uniqueString to generate a short unique name
// The result of `uniqueString('sample', 'dev', 'norwayeast')` = zmamywx7mjdhw
//=============================================================================

test testShortenedVirtualMachineNameWithoutInstance 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualMachine'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: ''
    expectedResult: 'vmzmamywx7mjdhw'
  }
}

test testShortenedVirtualMachineNameWithInstance001 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualMachine'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '001'
    expectedResult: 'vmzmamywx7mj001'
  }
}

test testShortenedVirtualMachineNameWithInstanceMain 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualMachine'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: 'main'
    expectedResult: 'vmzmamywx7mmain'
  }
}

test testShortenedVirtualMachineNameWithInstancePrimary 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualMachine'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: 'primary'
    expectedResult: 'vmzmamywprimary'
  }
}

test testShortenedVirtualMachineNameWithIllegalCharactersInInstance 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualMachine'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0;: 01_'
    expectedResult: 'vmzmamywx7mj001'
  }
}

test testShortenedVirtualMachineNameWithHypenInInstance 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualMachine'
    workload: 'sample'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0-01'
    expectedResult: 'vmzmamywx7mj001'
  }
}


//=============================================================================
// Sanitizing Name
//=============================================================================

test testSanitizeColon 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample;workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0;01'
    expectedResult: 'vnet-sampleworkload-dev-nwe-001'
  }
}

test testSanitizeComma 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample,workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0,01'
    expectedResult: 'vnet-sampleworkload-dev-nwe-001'
  }
}

test testSanitizeDot 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample.workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0.01'
    expectedResult: 'vnet-sampleworkload-dev-nwe-001'
  }
}

test testSanitizeSemicolon 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample:workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0:01'
    expectedResult: 'vnet-sampleworkload-dev-nwe-001'
  }
}

test testSanitizeUnderscore 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample_workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0_01'
    expectedResult: 'vnet-sampleworkload-dev-nwe-001'
  }
}

test testSanitizeWhiteSpace 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'sample workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: '0 01'
    expectedResult: 'vnet-sampleworkload-dev-nwe-001'
  }
}

test testSanitizUpperCaseToLowerCase 'test-get-resource-name.bicep' = {
  params: {
    resourceType: 'virtualNetwork'
    workload: 'Sample Workload'
    environment: 'dev'
    region: 'norwayeast'
    instance: 'Main'
    expectedResult: 'vnet-sampleworkload-dev-nwe-main'
  }
}
