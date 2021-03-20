variable "ibmcloud_api_key" {}



terraform {
  required_version = ">= 0.13"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.20.1"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  generation       = 2

}

