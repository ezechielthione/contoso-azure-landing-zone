# ============================================================
# ContosoFinance Landing Zone — Outputs
# Author  : Ezechiel Thione
# Date    : 2026-05-11
# ============================================================

output "rg_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "rg_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.rg.id
}

output "location" {
  description = "Deployment region"
  value       = azurerm_resource_group.rg.location
}