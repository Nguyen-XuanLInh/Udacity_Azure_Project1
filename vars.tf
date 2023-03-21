variable "prefix" {
  description = "Prefix"
  default = "udacity"
}

variable "Environment"{
  description = "environment"
  default = "test"
}

variable "location" {
  description = "Azure Region"
  default = "Australia East" 
}

variable "username"{
  default = "username"
}

variable "password"{
  default= "Password123$$$"
}

variable "server_names"{
  type = list
  default = ["uat","int"]
}

variable "packerImageId"{
  default = "/subscriptions/c9f1e8cb-24a3-405b-9046-bf2b34125d0c/resourceGroups/AZUREDEVOPS/providers/Microsoft.Compute/images/myPackerImage"
}

variable "vm_count"{
  default = "2"
}