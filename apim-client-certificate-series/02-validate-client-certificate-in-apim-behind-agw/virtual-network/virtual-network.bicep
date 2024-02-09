//=============================================================================
// Virtual Network
//=============================================================================


//=============================================================================
// Parameters
//=============================================================================

@description('Location to use for all resources')
param location string

//=============================================================================
// Resources
//=============================================================================


// Network Security Group for API Management subnet
resource apimNSG 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-apim-validate-client-certificate'
  location: location
  properties: {
    securityRules: [
      {
        name: 'management-endpoint-for-azure-portal-and-powershell'
        properties: {
          access: 'Allow'
          sourcePortRange: '*'
          destinationPortRange: '3443'
          direction: 'Inbound'
          protocol: 'TCP'
          sourceAddressPrefix: 'ApiManagement'
          destinationAddressPrefix: 'VirtualNetwork'
          priority: 110
        }
      }
      {
        name: 'azure-infrastructure-load-balancer'
        properties: {
          access: 'Allow'
          sourcePortRange: '*'
          destinationPortRange: '6390'
          direction: 'Inbound'
          protocol: 'TCP'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: 'VirtualNetwork'
          priority: 120
        }
      }
      {
        name: 'dependency-on-azure-storage'
        properties: {
          access: 'Allow'
          sourcePortRange: '*'
          destinationPortRange: '443'
          direction: 'Outbound'
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Storage'
          priority: 140
        }
      }
      {
        name: 'access-to-azure-sql-endpoints'
        properties: {
          access: 'Allow'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          direction: 'Outbound'
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Sql'
          priority: 150
        }
      }
      {
        name: 'access-to-azure-key-vault'
        properties: {
          access: 'Allow'
          sourcePortRange: '*'
          destinationPortRange: '443'
          direction: 'Outbound'
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureKeyVault'
          priority: 160
        }
      }
      {
        name: 'publish-diagnostics-logs-and-metrics-resource-health-and-application-insights'
        properties: {
          access: 'Allow'
          sourcePortRange: '*'
          destinationPortRange: '443'
          direction: 'Outbound'
          protocol: 'TCP'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureMonitor'
          priority: 170
        }
      }
    ]
  }
}


// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'vnet-validate-client-certificate'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-app-gateway'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'snet-api-management'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: apimNSG.id
          }
        }
      }
    ]
  }

  resource agwSubnet 'subnets' existing = {
    name: 'snet-app-gateway'
  }

  resource apimSubnet 'subnets' existing = {
    name: 'snet-api-management'
  }
}


//=============================================================================
// Outputs
//=============================================================================

output agwSubnetId string = virtualNetwork::agwSubnet.id
output apimSubnetId string = virtualNetwork::apimSubnet.id
