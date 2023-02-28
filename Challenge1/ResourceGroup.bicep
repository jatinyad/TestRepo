param location string
param resourceGroupName string

targetScope = 'subscription'

resource ResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
}
