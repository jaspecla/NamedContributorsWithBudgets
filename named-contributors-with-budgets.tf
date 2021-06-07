terraform {
  required_providers {
    azure-preview = {
      source = "innovationnorway/azure-preview"
      version = "0.1.0-alpha.3"
    }
  }
}

provider "azurerm" {
    features {}
    tenant_id = var.tenant_id
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
}

provider "azuread" {
}

provider "azure-preview" {
    tenant_id = var.tenant_id
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
}

variable "user_name" {
    description = "The name of the user for whom to create a resource group."
    type = string
}

variable "user_email" {
    description = "The email account used for the user to authenticate to Azure."
    type = string
}

variable "tenant_id" {
    type = string
}

variable "subscription_id" {
    type = string
}

variable "client_id" {
    type = string
}

variable "client_secret" {
    type = string
}

resource "azurerm_resource_group" "rg" {
    name = lower(replace(var.user_name, "/[[:space:]]+/", "_"))
    location = "eastus"
}

data "azuread_user" "ad_user" {
    user_principal_name = var.user_email
}

resource "azurerm_role_assignment" "role" {
    scope = azurerm_resource_group.rg.id
    role_definition_name = "Contributor"
    principal_id = data.azuread_user.ad_user.id
}


resource "azurepreview_budget" "budget" {
    name = "budget"
    scope = azurerm_resource_group.rg.id
    category = "Cost"
    amount = 1000
    time_grain = "BillingMonth"
    
    time_period {
        start_date = "2017-06-01T00:00:00Z"
        end_date   = "2035-06-01T00:00:00Z"
    }
    provider = azure-preview
}
