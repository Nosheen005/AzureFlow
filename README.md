# AzureFlow

AzureFlow is a project focused on **deploying a data pipeline to Microsoft Azure** using Infrastructure as Code (IaC) principles with **Terraform** and **Docker**.  

The data pipeline deployed in this project — **WarehouseWorks** — can be found here:  
[WarehouseWorks Repository](https://github.com/Nosheen005/WarehouseWorks)

---

## Overview

This project demonstrates how to automate the provisioning and deployment of a full Azure data pipeline environment.  
It includes:

- Infrastructure deployment via **Terraform**  
- Containerization with **Docker**  
- Integration with Azure services for scalable data processing  
- Cost estimation and deployment reproducibility  

---

## Prerequisites

Before getting started, make sure you have the following installed and configured:

- [Python](https://www.python.org/downloads/)  
- [Docker](https://www.docker.com/get-started)  
- [Terraform](https://developer.hashicorp.com/terraform/downloads)  
- An active **[Azure account](https://azure.microsoft.com/)**  
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

If you are new to **Terraform** or **Azure CLI**, we highly recommend checking out this resource by **AIgineer**:  
🔗 [AIgineer Azure Cloud Datapipeline Terraform Setup Guide](https://github.com/AIgineerAB/azure-cloud-datapipeline/tree/main/12_IaC_terraform_setup)

---

## Setup Instructions

1. **Clone this repository**

   ```bash
   git clone https://github.com/Nosheen005/AzureFlow.git
   cd AzureFlow
   ```
   
2. **Configure your Azure subscription**
Update your **Azure subscription ID** in the Terraform input variables file:  
Open `terraform/input-variables.tf` and change the value of the default in `subscription_id`:

   ```hcl
   variable "subscription_id" {
     description = "The Subscription ID for the Azure Account"
     default     = "your-subscription-id-here"
   }
   ```

3. **Initialize Terraform**

   ```bash
   terraform init
   ```

4. **Plan the deployment**

   ```bash
   terraform plan
   ```
   This will show you the infrastructure that Terraform plans to create.

5. **Apply the deployment**

   ```bash
   terraform apply
   ```
   Confirm the changes when prompted. Terraform will now deploy the infrastructure to your Azure account

If you change your mind you can easily remove everything terraform made in your azure account with
   ```bash
   terraform destroy
   ```
   
---

## Cost Information

The project includes a `cost_analysis.pdf` file that outlines estimated deployment costs.  
Please note that these are **approximate estimates** — your actual costs on Azure may vary depending on:

- Your specific Azure subscription and pricing tier  
- Regional pricing differences  
- Resource scaling and usage

Always review your **Azure Cost Management** dashboard after deployment.

---

## 🧩 Project Structure


```
AzureFlow/
├── dashboard/                # Streamlit dashboard from WarehouseWorks
├── dbt_analytics/            # DBT project of WarehouseWorks
├── extract_load/             # DLT of WarehouseWorks
├── orchestration/            # Dagster orchestration of WarehouseWorks
│
├── terraform/                # Terraform IaC configuration files
│   ├── input-variables.tf    # Variables including Azure subscription ID
│   ├── profiles.yml          # A dbt profiles.yml file used in WarehouseWorks pipeline
│   ├── outputs.tf            # Outputs from Terraform
│   ├── random.tf             # Gives a random string to append to unique names
│   └── ...                   # Individual terraform files for each Azure resource
│
├── docker-compose.tpl.yml    # A template docker compose for terraform
├── dockerfile.dashboard      # Dockerfile for dashboard part of WarehouseWorks
├── dockerfile.dwh            # Dockerfile for dagster part of WarehouseWorks
│
├── cost_analysis.pdf         # Cost estimation report for deployment
├── README.md                 # Project documentation (this file)
└── .gitignore                # Standard git ignore file
```
