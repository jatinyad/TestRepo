param loadBalancersName string
param virtualNetworkName string
param location string = resourceGroup().location

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworkName
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
          subnet: {
            id: '${virtualNetwork.id}/subnets/default'
          }
          privateIPAddressVersion: 'IPv4'
        }
        zones: [
          '1'
          '3'
          '2'
        ]
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
