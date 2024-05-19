//=============================================================================
// Securing backend connections with mTLS in API Management
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

@description('The name of the secret in the Key Vault that contains the client certificate')
param clientCertificateSecretName string = 'generated-client-certificate'


//=============================================================================
// Existing Resources
//=============================================================================

resource apiManagementServiceClient 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementServiceClientName
}

resource apiManagementServiceBackend 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementServiceBackendName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource clientCertificateSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' existing = {
  name: clientCertificateSecretName
  parent: keyVault
}


//=============================================================================
// Resources
//=============================================================================

// Create client certificate in API Management that references Key Vault

resource clientCertificate 'Microsoft.ApiManagement/service/certificates@2022-08-01' = {
  name: 'client-certificate'
  parent: apiManagementServiceClient
  properties: {
    keyVault: {
      secretIdentifier: clientCertificateSecret.properties.secretUri
    }
  }
}

// Create the backend inside the client API Management service

resource testBackend 'Microsoft.ApiManagement/service/backends@2022-08-01' = {
  name: 'test-backend'
  parent: apiManagementServiceClient
  properties: {
    url: apiManagementServiceBackend.properties.gatewayUrl
    protocol: 'http'
    credentials: {
      certificateIds: [
        clientCertificate.id
      ]
    }
    tls: {
      validateCertificateChain: true
      validateCertificateName: true
    }
  }
}


// Create the API that uses the backend

resource backendApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: 'backend-api'
  parent: apiManagementServiceClient
  properties: {
    displayName: 'Backend API'
    path: 'backend'
    protocols: [ 
      'https' 
    ]
    subscriptionRequired: false // Disable required subscription key for simplicity of the demo
  }

  // Set an API level policy so all operations use the backend
  resource policies 'policies' = {
    name: 'policy'
    properties: {
      value: '''
        <policies>
          <inbound>
            <base />
            <set-backend-service backend-id="test-backend" />
          </inbound>
          <backend><base /></backend>
          <outbound><base /></outbound>
          <on-error><base /></on-error>
        </policies>
      '''
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

  dependsOn: [
    testBackend
  ]
}
