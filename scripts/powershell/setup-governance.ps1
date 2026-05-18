# ============================================================
# Phase 1 — Governance Setup
# Author  : Ezechiel Thione
# Date    : 2026-05-18
# ============================================================

# --- MANAGEMENT GROUP ---
az account management-group create `
    --name "Corp" `
    --display-name "Corp"

az account management-group subscription add `
    --name "Corp" `
    --subscription "35de2e10-f8a8-4c0f-aef6-65cd46e136d4"

# --- RESOURCE GROUPS ---
$rgs = @("rg-identity","rg-network","rg-compute","rg-storage","rg-monitoring")
foreach ($rg in $rgs) {
    az group create `
        --name $rg `
        --location westeurope `
        --tags env=lab owner=az104 project=ContosoFinance
}

# --- ENTRA ID USERS & GROUPS ---
az ad group create --display-name "AZ104-Admins" --mail-nickname "AZ104-Admins"
az ad group create --display-name "AZ104-Readers" --mail-nickname "AZ104-Readers"

az ad user create `
    --display-name "Alice Admin" `
    --user-principal-name "alice.admin@ethioneprogmail.onmicrosoft.com" `
    --password "AzureL@b2026!" `
    --force-change-password-next-sign-in false

az ad user create `
    --display-name "Bob Developer" `
    --user-principal-name "bob.developer@ethioneprogmail.onmicrosoft.com" `
    --password "AzureL@b2026!" `
    --force-change-password-next-sign-in false

az ad user create `
    --display-name "Carol Reader" `
    --user-principal-name "carol.reader@ethioneprogmail.onmicrosoft.com" `
    --password "AzureL@b2026!" `
    --force-change-password-next-sign-in false

# --- GROUP MEMBERSHIP ---
az ad group member add --group "AZ104-Admins" --member-id "640f7204-9d57-470d-8276-52366abdb354"
az ad group member add --group "AZ104-Admins" --member-id "38e90f46-1db2-4b6f-aee3-8cfc928c8c22"
az ad group member add --group "AZ104-Readers" --member-id "4e6a6adf-a181-4e70-af91-020af82b29f9"

# --- RBAC ---
az role assignment create `
    --assignee "9fe17d62-cc90-4e9a-96d3-b0ebe1274c07" `
    --role "Contributor" `
    --scope "/subscriptions/35de2e10-f8a8-4c0f-aef6-65cd46e136d4/resourceGroups/rg-compute"

az role assignment create `
    --assignee "e364abe2-a737-4712-9b39-788b5d686eaf" `
    --role "Reader" `
    --scope "/subscriptions/35de2e10-f8a8-4c0f-aef6-65cd46e136d4"

# --- POLICIES ---
az policy definition create `
    --name "require-env-tag" `
    --display-name "Require env tag on all resources" `
    --description "Denies creation of resources without env tag" `
    --rules '@policies/require-env-tag.json' `
    --mode Indexed

az policy assignment create `
    --name "require-env-tag-assignment" `
    --display-name "Require env tag on all resources" `
    --policy "require-env-tag" `
    --scope "/subscriptions/35de2e10-f8a8-4c0f-aef6-65cd46e136d4"

az policy assignment create `
    --name "allowed-locations-audit" `
    --display-name "Audit resources outside West Europe" `
    --policy "e56962a6-4747-49cd-b67b-bf8b01975c4c" `
    --scope "/subscriptions/35de2e10-f8a8-4c0f-aef6-65cd46e136d4" `
    --params '@policies/allowed-locations-params.json'

# --- RESOURCE LOCK ---
az lock create `
    --name "lock-rg-network-nodelete" `
    --resource-group "rg-network" `
    --lock-type CanNotDelete `
    --notes "Network RG — deletion protected"