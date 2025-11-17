variable "subscription_id" {
  type        = string
  description = "Azure Subscription to deploy into. Run $env:TF_VAR_subscription_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' to set the subscription id before running terraform plan command"
}

variable "location" {
  type        = string
  description = "Azure Region to deploy resources into."
  default     = "eastus"
}











