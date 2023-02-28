param prefix string
param environment string
param locationShortName string
param location string
param userAdmin string
param vnetAddressPrefix string
param subnetAddressPrefix string
param imageReference object
param vmSize string
@secure()
param adminPassword string
@secure()
param sqlAdminPassword string

var sqlServerName = 'sql-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var sqlDBName = 'sqlDB-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var vnetName = 'vnet-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var resourceGroupName = 'rg-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var pipVM1 = 'pipVM1-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var pipVM2 = 'pipVM2-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var pipLB1 = 'pipLB1-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nsgVM1 = 'nsgVM1-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nsgVM2 = 'nsgVM2-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nsgVM3 = 'nsgVM3-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nsgVM4 = 'nsgVM4-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nicVM1 = 'nicVM1-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nicVM2 = 'nicVM2-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nicVM3 = 'nicVM3-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var nicVM4 = 'nicVM4-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var vm1 = 'vm1-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var vm2 = 'vm2-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var vm3 = 'vm3-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var vm4 = 'vm4-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var lb1 = 'lb1-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'
var lb2 = 'lb2-${toLower(prefix)}-${toLower(locationShortName)}-${toLower(environment)}'

var ipAddressName = [
  pipVM1
  pipVM2
  pipLB1
]

var nsgs = [
  nsgVM1
  nsgVM2
  nsgVM3
  nsgVM4
]

var nics = [
  {
    nicName: nicVM1
    publicIPAddressName: pipVM1
    nsgName: nsgVM1
  }
  {
    nicName: nicVM2
    publicIPAddressName: pipVM2
    nsgName: nsgVM1
  }
]
var nicPrivate = [
  {
    nicName: nicVM3
    nsgName: nsgVM1
  }
  {
    nicName: nicVM4
    nsgName: nsgVM1
  }
]

var vms = [
  {
    nicName: nicVM1
    virtualMachineName: vm1
  }
  {
    nicName: nicVM2
    virtualMachineName: vm2
  }
  {
    nicName: nicVM3
    virtualMachineName: vm3
  }
  {
    nicName: nicVM4
    virtualMachineName: vm4
  }
]

targetScope = 'subscription'

module resourcGroupModule 'ResourceGroup.bicep' = {
  name: 'resourceGroupDeploy'
  params: {
    location: location
    resourceGroupName: resourceGroupName
  }
}

module publicIPAddressesModule 'PublicIPAddress.bicep' = [for ipAddress in ipAddressName: {
  scope: resourceGroup(resourceGroupName)
  name: '${ipAddress}Deploy'
  params: {
    publicIPAddressName: ipAddress
  }
  dependsOn: [
    resourcGroupModule
  ]
}]

module sqlServerModule 'SQLServer.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'sqlServerDeploy'
  params: {
    sqlServerName: sqlServerName
    sqlAdmin: userAdmin
    sqlAdminPassword: sqlAdminPassword
  }
  dependsOn: [
    resourcGroupModule
  ]
}

module nsgModule 'NetworkSecurityGroup.bicep' = [for nsg in nsgs: {
  scope: resourceGroup(resourceGroupName)
  name: '${nsg}Deploy'
  params: {
    networkSecurityGroupName: nsg
  }
  dependsOn: [
    resourcGroupModule
  ]
}]

module vnetModule 'VirtualNetwork.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'vnetDeploy'
  params: {
    subnetAddressPrefix: subnetAddressPrefix
    virtualNetworkName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
  }
  dependsOn: [
    resourcGroupModule
  ]
}

module nicPublicModule 'NetworkInterfacePublic.bicep' = [for nic in nics: {
  scope: resourceGroup(resourceGroupName)
  name: '${nic.nicName}Deploy'
  params: {
    networkInterfaceName: nic.nicName
    nsgName: nic.nsgName
    virtualNetworkName: vnetModule.outputs.vnetName
    publicIPAddressName: nic.publicIPAddressName
  }
  dependsOn: [
    resourcGroupModule
    nsgModule
    vnetModule
    publicIPAddressesModule
  ]
}]

module nicPrivateModule 'NetworkInterfacePrivate.bicep' = [for nic in nicPrivate: {
  scope: resourceGroup(resourceGroupName)
  name: '${nic.nicName}Deploy'
  params: {
    networkInterfaceName: nic.nicName
    nsgName: nic.nsgName
    virtualNetworkName: vnetModule.outputs.vnetName
  }
  dependsOn: [
    resourcGroupModule
    nsgModule
    vnetModule
    publicIPAddressesModule
  ]
}]

module virtualMachineModule 'VirtualMachine.bicep' = [for vm in vms: {
  scope: resourceGroup(resourceGroupName)
  name: '${vm.virtualMachineName}Deploy'
  params: {
    imageReference: imageReference
    nicName: vm.nicName
    virtualMachineName: vm.virtualMachineName
    vmAdmin: userAdmin
    vmSize: vmSize
    adminPassword: adminPassword
  }
  dependsOn: [
    resourcGroupModule
    nicPublicModule
    nicPrivateModule
  ]
}]

module loadBalancerInternalModule 'LoadBalancerInternal.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'LBInternalDeploy'
  params: {
    loadBalancersName: lb2
    virtualNetworkName: vnetName
  }
  dependsOn: [
    resourcGroupModule
    vnetModule
  ]
}
module loadBalancerExternalModule 'LoadBalancerExternal.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'LbExternalDeploy'
  params: {
    loadBalancersName: lb1
    publicIPAddressName: pipLB1
  }
  dependsOn: [
    resourcGroupModule
    publicIPAddressesModule
  ]
}

module sqlDBModule 'SQLDatabase.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'sqlDBDeploy'
  params: {
    sqlDBName: sqlDBName
    sqlName: sqlServerName
  }
  dependsOn: [
    resourcGroupModule
    sqlServerModule
  ]
}
