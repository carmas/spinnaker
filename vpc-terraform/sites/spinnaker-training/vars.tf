variable  "access_key" {
   default = ""
} 

variable  "secret_key" {
   default = ""
}

variable "aws_region" {
  default = "us-west-2"
}


variable "vpc_id" {
  default = "none"
}

variable "av_zone1" {
  default = "a"
}

variable "av_zone2" {
  default = "b"
}

variable "vpc_cidr_block" {
   default = "10.102.0.0/16"
}
variable "tag_vpc_name" {
   default = "vpc-armory-spinnaker"
}

variable "subnet_size" {
   default = "8"
}


