param location string = resourceGroup().location
param sqlDBName string
param sqlName string

resource sql 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: sqlName
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sql
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 10
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 268435456000
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Geo'
  }
}
