// ============================================================
// ContosoFinance Landing Zone — Resource Group Foundation
// Author  : Ezechiel Thione
// Date    : 2026-05-11
// Version : 1.0.0
// ============================================================

// --- PARAMETERS ---
// targetScope defines where this template deploys
// 'subscription' = we deploy at subscription level (not inside a RG)
// because we are creating the RG itself
targetScope = 'subscription'

@description('Target environment: prod, dev, sandbox')
@allowed([
  'prod'
  'dev'
  'sandbox'
])
param environment string = 'dev'

@description('Primary Azure region')
param location string = 'westeurope'

@description('Creation date — for the CreatedDate tag')
param createdDate string = utcNow('yyyy-MM-dd')

// --- VARIABLES ---
// CAF naming convention: rg-<workload>-<env>-<region>-<number>
var rgName = 'rg-contoso-${environment}-westeu-001'
var lockName = 'lock-${rgName}-nodelete'

// Mandatory ContosoFinance tags — applied to all resources
var tags = {
  Environment: environment
  Project: 'ContosoFinance-LandingZone'
  CostCenter: 'IT-Cloud-001'
  Owner: 'ezechielthione'
  ManagedBy: 'Bicep'
  CreatedDate: createdDate
}

// --- RESOURCES ---

// 1. Resource Group creation
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: rgName
  location: location
  tags: tags
}

// 2. Resource Lock — deployed via module (different scope)
module rgLock '../../modules/resource-group-lock.bicep' = {
  name: lockName
  scope: rg
  params: {
    lockName: lockName
  }
}

// --- OUTPUTS ---
output rgName string = rg.name
output rgId string = rg.id
output location string = rg.location
