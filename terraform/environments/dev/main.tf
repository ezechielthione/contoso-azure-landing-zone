# ============================================================
# ContosoFinance Landing Zone — Main
# Author  : Ezechiel Thione
# Date    : 2026-05-11
# ============================================================

# Terraform configuration block
# Declares required providers and versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Azure provider configuration
# features {} is mandatory even if empty
provider "azurerm" {
  features {}
}

# --- LOCALS ---
# Same concept as Bicep variables — computed values
# CAF naming convention: rg-<workload>-<env>-<region>-<number>
locals {
  rg_name   = "rg-contoso-${var.environment}-westeu-001"
  lock_name = "lock-rg-contoso-${var.environment}-westeu-001-nodelete"
  tags = {
    Environment = var.environment
    Project     = var.project
    CostCenter  = "IT-Cloud-001"
    Owner       = "ezechielthione"
    ManagedBy   = "Terraform"
    CreatedDate = "2026-05-11"
  }
}
# --- RESOURCES ---

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

# 2. Resource Lock — CanNotDelete
resource "azurerm_management_lock" "rg_lock" {
  name       = local.lock_name
  scope      = azurerm_resource_group.rg.id
  lock_level = "CanNotDelete"
  notes      = "Dev RG — deletion protected. Remove lock before destroying."
}