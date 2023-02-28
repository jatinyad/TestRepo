param publicIPAddressName string
param location string = resourceGroup().location

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIPAddressName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

output pipID string = publicIPAddress.id
output pipName string = publicIPAddress.name
