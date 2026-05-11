# ============================================================
# ContosoFinance Landing Zone — Variables
# Author  : Ezechiel Thione
# Date    : 2026-05-11
# ============================================================

variable "environment" {
  description = "Target environment: prod, dev, sandbox"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Primary Azure region"
  type        = string
  default     = "westeurope"
}

variable "project" {
  description = "Project name for tags and naming"
  type        = string
  default     = "ContosoFinance-LandingZone"
}