variable "access_key" {
  type        = string
  description = "aws accesskey"
  default     = "ACCESSKEY"
}
variable "secret_key" {
  type        = string
  description = "aws secretkey"
  default     = "SECRETKEY"
}
variable "region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}


variable "ami" {
  type        = string
  description = "aws ami used to provision the VM"
  default     = "ami-0022f774911c1d690"
}

variable "instance_ssh_public_key" {
  type        = string
  description = "your ssh public key"
  default     = "PUBLICKEY"
}

data "http" "my_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  my_ip = data.http.my_public_ip.response_body
}
