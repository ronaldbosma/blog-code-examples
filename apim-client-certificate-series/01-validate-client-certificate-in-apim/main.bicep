//=============================================================================
// Prerequisites
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('The name of the API Management Service that will be created')
param apiManagementServiceName string

@description('Location to use for all resources')
param location string = resourceGroup().location

@description('The email address of the owner of the API Management service')
param publisherEmail string

@description('The name of the owner of the API Management service')
param publisherName string

//=============================================================================
// Resources
//=============================================================================

// API Management

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apiManagementServiceName
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    certificates: [
      {
        encodedCertificate: loadTextContent('../00-self-signed-certificates/certificates/root-ca.without-markers.cer')
        storeName: 'Root'
      }
      {
        encodedCertificate: loadTextContent('../00-self-signed-certificates/certificates/dev-intermediate-ca.without-markers.cer')
        storeName: 'CertificateAuthority'
      }
    ]
  }
}

// API

resource clientCertApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: 'client-cert-api'
  parent: apiManagementService
  properties: {
    displayName: 'Client Cert API'
    path: 'client-cert'
    protocols: [ 
      'https' 
    ]
  }

  resource validateUsingPolicy 'operations' = {
    name: 'validate-using-policy'
    properties: {
      displayName: 'Validate (using policy)'
      description: 'Validates client certificate using validate-client-certificate policy'
      method: 'GET'
      urlTemplate: '/validate-using-policy'
    }

    resource policies 'policies' = {
      name: 'policy'
      properties: {
        format: 'rawxml'
        value: loadTextContent('./validate-using-policy.operation.cshtml') 
      }
    }
  }

  resource validateUsingContext 'operations' = {
    name: 'validate-using-context'
    properties: {
      displayName: 'Validate (using context)'
      description: 'Validates client certificate using the context.Request.Certificate property'
      method: 'GET'
      urlTemplate: '/validate-using-context'
    }

    resource policies 'policies' = {
      name: 'policy'
      properties: {
        format: 'rawxml'
        value: loadTextContent('./validate-using-context.operation.cshtml') 
      }
    }
  }
}
