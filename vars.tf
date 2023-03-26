variable "prefix" {
  description = "Prefix"
  default = "udacity"
}

variable "environment"{
  description = "environment"
  default = "test"
}

variable "resourceGroup" {
  description = "Name of resource"
  default     = "Azuredevops"
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
  default = "e7a256dc-769a-421c-9f8e-e283ed3cbefa"
}

variable "vmCount"{
  default = "2"
}