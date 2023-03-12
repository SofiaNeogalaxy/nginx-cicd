variable "region" {
  description = "Region of resources deployment"
}

variable "group" {
  description = "Used by ansible to group hosts"
}

variable "name" {
  description = "Name of instance being launched"
}

variable "instance_type" {
  description = "Instance type to be launched"
  default     = "t2.micro"
}