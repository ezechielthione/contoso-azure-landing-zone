# ============================================================
# Phase 2 — Storage Setup
# Author  : Ezechiel Thione
# Date    : 2026-05-22
# ============================================================

# --- STORAGE ACCOUNT ---
az storage account create `
    --name "stcontoso2026lab" `
    --resource-group "rg-storage" `
    --location westeurope `
    --sku Standard_ZRS `
    --kind StorageV2 `
    --access-tier Hot `
    --https-only true `
    --allow-blob-public-access false `
    --allow-shared-key-access false `
    --default-action Allow `
    --min-tls-version TLS1_2 `
    --tags env=lab owner=az104 project=ContosoFinance

# --- RBAC ---
az role assignment create `
    --assignee "d3fc89fa-c638-4ca4-9bd4-0ecaeafc6d95" `
    --role "Storage Blob Data Contributor" `
    --scope "/subscriptions/35de2e10-f8a8-4c0f-aef6-65cd46e136d4/resourceGroups/rg-storage/providers/Microsoft.Storage/storageAccounts/stcontoso2026lab"

# --- BLOB CONTAINER ---
az storage container create `
    --name "lab-container-cli" `
    --account-name "stcontoso2026lab" `
    --auth-mode login `
    --public-access off

# --- UPLOAD BLOB ---
az storage blob upload `
    --account-name "stcontoso2026lab" `
    --container-name "lab-container-cli" `
    --name "test-blob.txt" `
    --file "test-blob.txt" `
    --auth-mode login

# --- SAS TOKEN ---
$expiry = (Get-Date).AddHours(1).ToUniversalTime().ToString("yyyy-MM-ddTHH:mmZ")
az storage blob generate-sas `
    --account-name "stcontoso2026lab" `
    --container-name "lab-container-cli" `
    --name "test-blob.txt" `
    --permissions r `
    --expiry $expiry `
    --auth-mode login `
    --as-user `
    --output tsv

# --- LIFECYCLE POLICY ---
az storage account management-policy create `
    --account-name "stcontoso2026lab" `
    --resource-group "rg-storage" `
    --policy @policies/lifecycle-policy.json

# Note: Azure Files CLI creation requires key access
# Use portal for file share creation when key access is disabled