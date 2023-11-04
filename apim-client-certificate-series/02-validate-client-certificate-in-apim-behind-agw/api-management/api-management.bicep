//=============================================================================
// Azure API Management
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
        encodedCertificate: loadTextContent('../../00-self-signed-certificates/certificates/root-ca.without-markers.cer')
        storeName: 'Root'
      }
      {
        encodedCertificate: loadTextContent('../../00-self-signed-certificates/certificates/dev-intermediate-ca.without-markers.cer')
        storeName: 'CertificateAuthority'
      }
    ]
  }
}


// Add client certificate for 'Dev Client 01'
resource devClient01Certificate 'Microsoft.ApiManagement/service/certificates@2022-08-01' = {
  name: 'dev-client-01'
  parent: apiManagementService
  properties: {
    data: loadTextContent('../../00-self-signed-certificates/certificates/dev-client-01.without-markers.cer')
  }
}


// Client Cert API
resource clientCertApi 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  name: 'client-cert-api'
  parent: apiManagementService
  properties: {
    displayName: 'Client Cert API'
    path: 'client-cert'
    protocols: [ 
      'https' 
    ]
    subscriptionRequired: false
  }
}


// Operation to validate client certificate
resource validateOperation 'Microsoft.ApiManagement/service/apis/operations@2022-08-01' = {
  name: 'validate'
  parent: clientCertApi
  properties: {
    displayName: 'Validate'
    description: 'Validates client certificate'
    method: 'GET'
    urlTemplate: '/validate'
  }

  resource policies 'policies' = {
    name: 'policy'
    properties: {
      format: 'rawxml'
      value: loadTextContent('./validate.operation.cshtml') 
    }
  }
}
