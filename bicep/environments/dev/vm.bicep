// ============================================================
// ContosoFinance Landing Zone — Virtual Machine
// Author  : Ezechiel Thione
// Date    : 2026-05-26
// ============================================================

targetScope = 'resourceGroup'

// --- PARAMETERS ---
@description('VM name')
param vmName string = 'vm-windows-prod-westeu-001'

@description('Admin username')
param adminUsername string = 'azureadmin'

@description('Admin password')
@secure()
param adminPassword string

@description('VM size')
param vmSize string = 'Standard_D2s_v3'

@description('Location')
param location string = resourceGroup().location

// --- VARIABLES ---
var nicName = '${vmName}-nic'
var vnetName = '${vmName}-vnet'
var subnetName = 'default'
var osDiskName = '${vmName}-osdisk'

var tags = {
  Environment: 'dev'
  Project: 'ContosoFinance-LandingZone'
  CostCenter: 'IT-Cloud-001'
  Owner: 'ezechielthione'
  ManagedBy: 'Bicep'
}

// --- RESOURCES ---

// 1. Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// 2. Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vnet.id}/subnets/${subnetName}'
          }
        }
      }
    ]
  }
}

// 3. Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'vm-windows-prod'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        name: osDiskName
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}

// --- OUTPUTS ---
output vmId string = vm.id
output privateIpAddress string = nic.properties.ipConfigurations[0].properties.privateIPAddress
