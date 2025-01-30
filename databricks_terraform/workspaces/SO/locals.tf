locals {
    #volumes
    config_volumes = yamldecode(file("${path.module}/volumes.yml")) 
    #data_access
    config_data_access = yamldecode(file("${path.module}/workspaces_data_access.yml"))

    #External_locations
    external_locations = yamldecode(file("${path.module}/external_locations.yml")) 
    #Unity
    unity_dev = yamldecode(file("${path.module}/unity_dev.yml"))
    unity_qa = yamldecode(file("${path.module}/unity_dev.yml"))
    unity_prod = yamldecode(file("${path.module}/unity_dev.yml"))
    
    all_data_access_unity = { "catalogs": concat(local.unity_dev, local.unity_qa, local.unity_prod)}

    catalogs_grants = flatten([
        for catalog in local.all_data_access_unity.catalogs:
  
                    catalog = catalog.catalog_name
                    grants = grant.grant_name
            
    ])
    
    schemas_grants = flatten([
        for catalog in local.all_data_access_unity.catalogs:
        [
            for schema in catalog.schemas:
            {
                catalog_name = catalog.catalog_name
                schema_name  = schema.schema_name
                grants       = schema.grants
            }if contains(keys(schema), "grants")
        ] if contains(keys(catalog), "schemas")
    ])

tables_grants = flatten([
    for catalog in local.all_data_access_unity.catalogs:
    [
        for schema in catalog.schemas:
        [
            for table in schema.tables:
            {
                catalog_name = catalog.catalog_name
                schema_name  = schema.schema_name
                table_name   = table.table_name
                grants       = table.grants
            } if contains(keys(table), "grants")
        ] if contains(keys(schema), "tables")
    ] if contains(keys(catalog), "schemas")
])




}