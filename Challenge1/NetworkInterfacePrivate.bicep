param networkInterfaceName string
param location string = resourceGroup().location
param virtualNetworkName string
param nsgName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworkName
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-07-01' existing = {
  name: nsgName
}
resource networkInterfaces 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetwork.id}/subnets/default'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
    nicType: 'Standard'
  }
}
