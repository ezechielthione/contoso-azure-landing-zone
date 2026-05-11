// ============================================================
// Module: Resource Group Lock
// Author  : Ezechiel Thione
// Date    : 2026-05-11
// ============================================================

// This module deploys at resource group level
targetScope = 'resourceGroup'

// --- PARAMETERS ---
@description('Name of the lock')
param lockName string

// --- RESOURCES ---
// CanNotDelete lock — protects RG from accidental deletion
resource lock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: lockName
  properties: {
    level: 'CanNotDelete'
    notes: 'Dev RG — deletion protected. Remove lock before destroying.'
  }
}
