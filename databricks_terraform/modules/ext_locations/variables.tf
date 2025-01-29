variable "databricks_host" {
    description = "The Databricks workspace host URL"
    type        = string
}

variable "azure_client_id" {
    description = "The Azure client ID"
    type        = string
}

variable "azure_client_secret" {
    description = "The Azure client secret"
    type        = string
    sensitive   = true
}

variable "tenant_id" {
    description = "The Azure tenant ID"
    type        = string
}
