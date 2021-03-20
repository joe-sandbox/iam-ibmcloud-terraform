variable "project_name" {
    type = string  
    default = "myproject"
}
variable "new_users"{
    type = list(string)
}
variable "iam_roles" {
  default =  [ "Viewer"]
}
# creates a resource group
resource "ibm_resource_group" "project-rg" {
  name     = "${var.project_name}-rg"
}
resource "ibm_iam_user_invite" "invite_user" {
    users = var.new_users
    iam_policy {
      #roles  = ["Manager", "Viewer", "Administrator"]
      roles = var.iam_roles
      resources {
        service           = "containers-kubernetes"
        resource_group_id = ibm_resource_group.project-rg.id
      }
    }
}