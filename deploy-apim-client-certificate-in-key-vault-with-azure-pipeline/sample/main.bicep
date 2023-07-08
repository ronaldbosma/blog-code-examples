//=============================================================================
// Sample
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('The name of the Key Vault that contains the client certificate')
param keyVaultName string

@description('The name of the client certificate in Key Vault')
param clientCertificateName string

@description('The name of the API Management Service')
param apiManagementServiceName string

//=============================================================================
// Existing resources
//=============================================================================

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

resource clientCertificateSecret 'Microsoft.KeyVault/vaults/secrets@2023-02-01' existing = {
  name: clientCertificateName
  parent: keyVault
}

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementServiceName
}


//=============================================================================
// Resources
//=============================================================================


// Create client certificate in API Management that references Key Vault

resource clientCertificate 'Microsoft.ApiManagement/service/certificates@2022-08-01' = {
  name: 'my-sample-client-certificate'
  parent: apiManagementService
  properties: {
    keyVault: {
      secretIdentifier: clientCertificateSecret.properties.secretUri
    }
  }
}


// Create the backend to the external Echo API

resource echoBackend 'Microsoft.ApiManagement/service/backends@2022-08-01' = {
  name: 'echo-backend'
  parent: apiManagementService
  properties: {
    url: 'http://echoapi.cloudapp.net/api'
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


// Create the API that uses the echo backend

resource echoApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: 'echo-api'
  parent: apiManagementService
  properties: {
    displayName: 'Echo API'
    path: 'echo'
    protocols: [ 
      'https' 
    ]
  }

  // Set an API level policy so all operations use the echo-backend
  resource policies 'policies' = {
    name: 'policy'
    properties: {
      value: '<policies><inbound><base /><set-backend-service backend-id="echo-backend" /></inbound><backend><base /></backend><outbound><base /></outbound><on-error><base /></on-error></policies>'
    }
  }

  // Create a POST operation
  resource operations 'operations' = {
    name: 'post'
    properties: {
      displayName: 'Post'
      method: 'POST'
      urlTemplate: '/'
    }
  }

  dependsOn: [
    echoBackend // Depend on the backend because it's used in the policy
  ]
}
