#ansible-dev vpc cidr block definition
variable "ansible-cidr" {
  description = "ansible vpc cidr block"
  type        = string
  default     = "10.3.0.0/16" 
}

#ansible-dev subnet cidr block definition
variable "ansible-subnet-cidr" {
  description = "ansible subnet cidr block"
  type        = string
  default     = "10.3.0.0/16" 
}