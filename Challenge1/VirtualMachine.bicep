param virtualMachineName string
param vmSize string
param imageReference object
param vmAdmin string
param nicName string
@secure()
param adminPassword string
param location string = resourceGroup().location

resource networkInterfaces 'Microsoft.Network/networkInterfaces@2022-07-01' existing = {
  name: nicName
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: imageReference.publisher
        offer: imageReference.offer
        sku: imageReference.sku
        version: imageReference.version
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: vmAdmin
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
  }
}
