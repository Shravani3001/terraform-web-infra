variable "region" {
    default = "us-east-1" 
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    default = "web-infra-key"
}

variable "public_key_path" {
    default = "./web-infra-key.pub"
}