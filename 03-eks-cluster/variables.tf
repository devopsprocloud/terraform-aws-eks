
variable "project_name" {
  type    = string
  default = "roboshop"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  default = "roboshop"
}
variable "common_tags" {
  type = map(any)
  default = {
    Project     = "roboshop"
    Environment = "dev"
    Terraform   = "true"
  }
}