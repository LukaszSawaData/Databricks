# Description
Databricks Serverless Compute is a fully managed compute option that allows users to process data without worrying about provisioning or maintaining underlying infrastructure. Instead of managing clusters, users can focus entirely on developing data pipelines, running analytics, and leveraging machine learning workflows. Serverless Compute dynamically allocates resources based on workload demands, ensuring efficient use of compute resources while minimizing idle costs.

In Databricks, serverless compute is a cloud-based model that automatically handles and scales the infrastructure for your data processing tasks. With Databricks Serverless Compute, resources adjust dynamically based on demand, ensuring you only pay for what you use. Plus, it builds on the serverless compute options already available for Databricks SQL and Model Serving, further expanding its impact across a broad range of ETL workloads powered by Apache Spark and DLT.

For example, imagine you’re running an ETL pipeline to predict the latest trend in avocado toast (we’ve all been there). You don’t want to spend time thinking about managing servers or cluster configurations — you want insights. Serverless compute scales your infrastructure dynamically, giving you the compute power you need exactly when you need it. No sweat.
Under the hood, serverless compute uses Lakeguard to isolate user code using sandboxing techniques, an absolute necessity in a serverless environment.

<img width="456" height="304" alt="image" src="https://github.com/user-attachments/assets/65a29e9b-0b34-4033-823a-cf6db44717ee" />


# Requirements 

-  Unity Catalog enabled
-  Because serverless compute for workflows uses standard access mode, your workloads must support this access mode.
-  Databricks workspace must be in a supported region for serverless compute
# Glowne cechy: 


|Feature| Description|
|Automatic Scaling| 
|Photon|
| Databricks Runtime|Databricks automatically upgrades 
|Auto-optimization |

# Auto Optimisation: 
Serverless compute for workflows auto-optimization automatically optimizes the compute used to run your jobs and retries failed tasks. Auto-optimization is enabled by default, and Databricks recommends leaving it enabled to ensure critical workloads run successfully at least once. However, if you have workloads that must be executed at most once, for example, jobs that are not idempotent, you can turn off auto-optimization when adding or editing a task
<img width="646" height="246" alt="image" src="https://github.com/user-attachments/assets/c37334bb-9c88-432a-979b-6ab2063e72bf" />


# Serverless SQL Warehouses
 

# Types
## Serverless SQL Warehouses: 
- Running sporadic SQL
- They spin up quickly (under 10 seconds) and terminate when idle
- Allocate resources just for the duration of the task and shut down automatically when the job completes


## Serverless
- wyjasnic to: https://learn.microsoft.com/en-us/azure/databricks/jobs/run-serverless-jobs#performance


# Where use Severless
## Notebook
## Lakeflow
## Jobs
Serverless compute is supported with the notebook,** Python script**, **dbt, Python wheel, and JAR task types**
Serverless pipelines always use Unity Catalog
When you create a new pipeline, the default is to use serverless. 
# Use Cases

Serverless SQL Warehouses: 



# Costs 
## Budget Policy
- Jak ustawic Budget policy ??? Dopytac o to 
https://learn.microsoft.com/en-us/azure/databricks/ldp/serverless#policy
# Network
- NCC ensures private, managed connectivity between Databricks Serverless compute and your data sources, such as Azure Data Lake Storage
- Azure Private Link: This ensures that all communication between Serverless compute and your Azure resources happens securely, without exposing traffic to the public internet.


Data quality monitoring and predictive optimization are also billed under the serverless jobs SKU.

Serverless compute does not have to be enabled to use these two features.


# Works with DAB




# Works with SDK

# Managing Dependancies 
- There is no Init script
- Notebook-Scoped Libraries: %pip

# Switch existing job to Serverless
- UI
- DAB
When you enable serverless, any compute settings you have configured for a pipeline are removed. If you switch a pipeline back to non-serverless updates, you must reconfigure the desired compute settings to the pipeline configuration.
## Moving cluster tag to job tag: 

<img width="458" height="211" alt="image" src="https://github.com/user-attachments/assets/1085ca9d-6405-4a54-802a-c8084f224229" />



# Limitations: 
## Logging and Monitoring:
- Spark logs and the Spark UI are not available
## External Data Ingestion: 
-  Because serverless compute does not support JAR file installation, you cannot use a JDBC or ODBC driver to ingest data from an external data source.
## Higher Costs for Continuous Workloads
- For always-on tasks, provisioned clusters might be more cost-effective.
## Spark configuration parameters at the session level
[Spark configuration parameters at the session level](https://learn.microsoft.com/en-us/azure/databricks/jobs/run-serverless-jobs#set-spark-config)
## Cannot manually add compute settings in a clusters object in the JSON configuration for a serverless pipeline. Attempting to do so results in an error.
https://docs.databricks.com/aws/en/compute/serverless/limitations
You cannot manually add compute settings in a clusters object in the JSON configuration for a serverless pipeline. Attempting to do so results in an error.

# Support third party tools
## ADF
<img width="627" height="544" alt="image" src="https://github.com/user-attachments/assets/dfe9fe5b-8c31-4a4c-8083-252221afddf1" />

# convert existing pipelines 





https://medium.com/sync-computing/top-9-lessons-learned-about-databricks-jobs-serverless-41a43e99ded5
