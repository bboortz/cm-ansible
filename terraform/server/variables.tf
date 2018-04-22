variable "access_key" {}
variable "secret_key" {}
variable "vpc_id" {}

variable "region" {
  default = "eu-central-1"
}

variable "az-blue" {
  default = "eu-central-1a"
}
variable "az-green" {
  default = "eu-central-1b"
}

variable "lb-instance-flavor" {
  default = "ami-7c412f13"
}
