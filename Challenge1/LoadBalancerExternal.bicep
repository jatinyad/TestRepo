param loadBalancersName string
param publicIPAddressName string
param location string = resourceGroup().location

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-07-01' existing = {
  name: publicIPAddressName
}

resource loadBalancers 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: loadBalancersName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: loadBalancersName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddress.id
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    backendAddressPools: [
    ]
    loadBalancingRules: []
    probes: []
    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
}
