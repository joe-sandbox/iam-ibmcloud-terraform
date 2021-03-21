variable "project_name" {
    type = string  
    default = "myproject"
}
variable "admins_users"{
    type = list(string)
}
variable "devs_users"{
    type = list(string)
}
variable "iam_roles" {
  default =  [ "Viewer"]
}
# creates a resource group
resource "ibm_resource_group" "project-prod-rg" {
  name     = "${var.project_name}-prod-rg"
}
resource "ibm_resource_group" "project-test-rg" {
  name     = "${var.project_name}-test-rg"
}
resource "ibm_resource_group" "project-dev-rg" {
  name     = "${var.project_name}-dev-rg"
}
#creates service id
resource "ibm_iam_service_id" "serviceID_prod" {
  name = "${var.project_name}-prod-svc"
}
resource "ibm_iam_service_id" "serviceID_dev" {
  name = "${var.project_name}-dev-svc"
}
###creates access groups
resource "ibm_iam_access_group" "access-group-admin" {
  name        = "${var.project_name}-admins-ag"
  description = "Access group for admins of project ${var.project_name}"
}
resource "ibm_iam_access_group" "access-group-dev" {
  name        = "${var.project_name}-devs-ag"
  description = "Access group for devs of project ${var.project_name}"
}

### Assigns members to access groups
resource "ibm_iam_access_group_members" "members-ag-admins" {
  access_group_id = ibm_iam_access_group.access-group-admin.id
  ibm_ids         = var.admins_users
  iam_service_ids = [ibm_iam_service_id.serviceID_prod.id]
}

resource "ibm_iam_access_group_members" "members-ag-devs" {
  access_group_id = ibm_iam_access_group.access-group-dev.id
  ibm_ids         = var.devs_users
  iam_service_ids = [ibm_iam_service_id.serviceID_dev.id]
}



### creates the policies
resource "ibm_iam_access_group_policy" "policy-admins-dev" {
  access_group_id = ibm_iam_access_group.access-group-admin.id
  roles        = ["Administrator"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-dev-rg.id
  }
}
resource "ibm_iam_access_group_policy" "policy-admins-test" {
  access_group_id = ibm_iam_access_group.access-group-admin.id
  roles        = ["Administrator"]

  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-test-rg.id
  }
}
resource "ibm_iam_access_group_policy" "policy-admins-prod" {
  access_group_id = ibm_iam_access_group.access-group-admin.id
  roles        = ["Administrator"]

  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-prod-rg.id
  }
}

resource "ibm_iam_access_group_policy" "policy-devs" {
  access_group_id = ibm_iam_access_group.access-group-dev.id
  roles        = ["Editor"]

  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-dev-rg.id
  }
}

resource "ibm_iam_access_group_policy" "policy-test" {
  access_group_id = ibm_iam_access_group.access-group-dev.id
  roles        = ["Editor"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-test-rg.id
  }
}

resource "ibm_iam_service_policy" "policy-service-id-prod" {
  iam_service_id = ibm_iam_service_id.serviceID_prod.id
  roles        = ["Editor"]

  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-prod-rg.id
  }
}

resource "ibm_iam_service_policy" "policy-service-id-dev" {
  iam_service_id = ibm_iam_service_id.serviceID_dev.id
  roles        = ["Editor"]

  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-dev-rg.id
  }
}
resource "ibm_iam_service_policy" "policy-service-id-test" {
  iam_service_id = ibm_iam_service_id.serviceID_dev.id
  roles        = ["Editor"]
  resources {
    resource_type = "resource-group"
    resource      = ibm_resource_group.project-test-rg.id
  }
}
