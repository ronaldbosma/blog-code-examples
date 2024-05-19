//=============================================================================
// Prerequisites
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('The name of the API Management Service that will be the client side of the connection')
param apiManagementServiceClientName string

@description('The name of the API Management Service that will be the backend side of the connection')
param apiManagementServiceBackendName string

@description('The name of the Key Vault that will contain the client certificate')
@maxLength(24)
param keyVaultName string


//=============================================================================
// Existing Resources
//=============================================================================

resource apiManagementServiceClient 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementServiceClientName
}

resource apiManagementServiceBackend 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementServiceBackendName
}

//=============================================================================
// Resources
//=============================================================================


// Create the backend inside the client API Management service

resource testBackend 'Microsoft.ApiManagement/service/backends@2022-08-01' = {
  name: 'test-backend'
  parent: apiManagementServiceClient
  properties: {
    url: apiManagementServiceBackend.properties.gatewayUrl
    protocol: 'http'
    tls: {
      validateCertificateChain: true
      validateCertificateName: true
    }
  }
}


// Create the API that uses the backend

resource testApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: 'test-api'
  parent: apiManagementServiceClient
  properties: {
    displayName: 'Test API'
    path: 'test'
    protocols: [ 
      'https' 
    ]
    subscriptionRequired: false // Disable required subscription key for simplicity of the demo
  }

  // Set an API level policy so all operations use the backend
  resource policies 'policies' = {
    name: 'policy'
    properties: {
      value: '<policies><inbound><base /><set-backend-service backend-id="${testBackend.name}" /></inbound><backend><base /></backend><outbound><base /></outbound><on-error><base /></on-error></policies>'
    }
  }

  // Create a GET Backend Status operation
  resource operations 'operations' = {
    name: 'get-backend-status'
    properties: {
      displayName: 'GET Backend Status'
      method: 'GET'
      urlTemplate: '/internal-status-0123456789abcdef'
    }
  }
}
