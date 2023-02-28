param virtualNetworkName string
param location string = resourceGroup().location
param vnetAddressPrefix string
param subnetAddressPrefix string

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: subnetAddressPrefix
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    enableDdosProtection: false
  }
}

output vnetName string = virtualNetworks.name
