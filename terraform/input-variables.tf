variable "subscription_id" {
    description = "The Subscription ID for the Azure Account"
    default = 
}

#Resource Group Variables
variable "resource_group_name" {
    description = "Name of the Azure user to differentiate from others"
    default = "AzureFlow-RG"
}
variable "location" {
    description = "location to be used for resources"
    default     = "swedencentral"
}

#Container Registry Variables
variable "acr_name" {
    description = "The name of the Azure Container Registry"
    default     = "containazureflow"
}
variable "acr_sku" {
    description = "The SKU of the Azure Container Registry"
    default     = "Basic"
}

#Storage Account Variables
variable "storage_account_name" {
    description = "The name of the Storage Account"
    default     = "storeazureflow"
}
variable "file_share_name" {
    description = "The name of the File Share in the Storage Account"
    default     = "shareazureflow"
}
variable "file_share_size" {
    description = "The size of the File Share in GB"
    default     = 50
}

#Web App Variables
variable "web_app_name" {
    description = "The name of the Web App"
    default     = "webazureflow"
}
variable "dashboard_image_name" {
    description = "The name of the Dashboard Image"
    default     = "dashboard"
}
variable "dashboard_image_tag" {
    description = "The tag of the Dashboard Image"
    default     = "latest"
}

#Dagster ACI Variables
variable "dagster_container_name" {
  description = "Name of the Dagster Azure Container Instance"
  default     = "dagster-aci"
}

variable "dagster_image_name" {
  description = "Name of the Dagster image in ACR"
  default     = "pipeline"
}

variable "dagster_image_tag" {
  description = "Tag for the Dagster Docker image"
  default     = "latest"
}

variable "dagster_port" {
  description = "Port exposed by Dagster's web server"
  default     = 3000
}

variable "dagster_dns_label" {
  description = "DNS label for Dagster ACI (must be unique in region)"
  default     = "azureflowdagster-pipeline"
}
