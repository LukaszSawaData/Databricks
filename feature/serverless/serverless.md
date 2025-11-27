# Description




# Glowne cechy: 


|Feature| Description
Automatic Scaling| 
Speed

# Serverless SQL Warehouses
 

# Types
## Serverless SQL Warehouses: 
- Running sporadic SQL
- They spin up quickly (under 10 seconds) and terminate when idle
- Allocate resources just for the duration of the task and shut down automatically when the job completes


## Serverless Jobs: 
- 


# Use Cases

Serverless SQL Warehouses: 



# Costs 



# Network
- NCC ensures private, managed connectivity between Databricks Serverless compute and your data sources, such as Azure Data Lake Storage
- Azure Private Link: This ensures that all communication between Serverless compute and your Azure resources happens securely, without exposing traffic to the public internet.





# Works with DAB






# Managing Dependancies 
- There is no Init script
- Notebook-Scoped Libraries: %pip



# Limitations: 
## Logging and Monitoring:
- Spark logs and the Spark UI are not available
## External Data Ingestion: 
-  Because serverless compute does not support JAR file installation, you cannot use a JDBC or ODBC driver to ingest data from an external data source.
## Higher Costs for Continuous Workloads
- For always-on tasks, provisioned clusters might be more cost-effective.
