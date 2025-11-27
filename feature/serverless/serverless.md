# Description


# Requirements 

-  Unity Catalog enabled
-  Because serverless compute for workflows uses standard access mode, your workloads must support this access mode.
-  Databricks workspace must be in a supported region for serverless compute
# Glowne cechy: 


|Feature| Description|
|Automatic Scaling| 
|Photon|
| Databricks Runtime|Databricks automatically upgrades 


# Serverless SQL Warehouses
 

# Types
## Serverless SQL Warehouses: 
- Running sporadic SQL
- They spin up quickly (under 10 seconds) and terminate when idle
- Allocate resources just for the duration of the task and shut down automatically when the job completes


## Serverless



# Where use Severless
## Notebook
## Lakeflow
## Jobs
Serverless compute is supported with the notebook,** Python script**, **dbt, Python wheel, and JAR task types**


# Use Cases

Serverless SQL Warehouses: 



# Costs 
## Budget Policy
- Jak ustawic Budget policy ??? Dopytac o to 

# Network
- NCC ensures private, managed connectivity between Databricks Serverless compute and your data sources, such as Azure Data Lake Storage
- Azure Private Link: This ensures that all communication between Serverless compute and your Azure resources happens securely, without exposing traffic to the public internet.





# Works with DAB




# Works with SDK

# Managing Dependancies 
- There is no Init script
- Notebook-Scoped Libraries: %pip

# Switch existing job to Serverless
- UI
- DAB

## Moving cluster tag to job tag: 

<img width="458" height="211" alt="image" src="https://github.com/user-attachments/assets/1085ca9d-6405-4a54-802a-c8084f224229" />



# Limitations: 
## Logging and Monitoring:
- Spark logs and the Spark UI are not available
## External Data Ingestion: 
-  Because serverless compute does not support JAR file installation, you cannot use a JDBC or ODBC driver to ingest data from an external data source.
## Higher Costs for Continuous Workloads
- For always-on tasks, provisioned clusters might be more cost-effective.
