terraform {
    required_providers {
        databricks = {
            source  = "databricks/databricks"
            version = ">= 1.38.0"
        }
    }
}

provider "databricks" {
    host               = var.databricks_host
    azure_client_id    = var.azure_client_id
    azure_client_secret = var.azure_client_secret
    azure_tenant_id = var.tenat_id
}


resource "databricks_external_location" "locations" {
    for_each = {for loc in var.external_locations : loc.name => loc}
    name                 = each.value.name
    url                  = each.value.url
    credetial_name       = external_location.value.storage_credential_id
    owner                = each.value.owner
}