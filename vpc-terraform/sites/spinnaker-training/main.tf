
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region      = "${var.aws_region}"
}

#create VPC
module "vpc" {
   source          = "../../modules/vpc" 
   vpc_cidr_block  = "${var.vpc_cidr_block}"
   tag_vpc_name    = "${var.tag_vpc_name}"
}

# Create IGW
module "igw" {
   source       = "../../modules/igw"
   vpc_id       = "${module.vpc.vpc_id}"
   tag_igw_name = "${var.aws_region}-${module.vpc.vpc_tag_name}-igw-1"
}

# 


# External subnets
module "subnet-ext1" {
   source            = "../../modules/subnet"
   vpc_id            = "${module.vpc.vpc_id}"
   subnet_cidr_block = "${cidrsubnet("${var.vpc_cidr_block}","${var.subnet_size}",2)}"
   availability_zone = "${var.aws_region}${var.av_zone1}"
   tag_subnet_name   = "${var.aws_region}${var.av_zone1}-${module.vpc.vpc_tag_name}-ext-1"
   tag_subnet_type   = "external" 
}


module "subnet-ext2" {
   source            = "../../modules/subnet"
   vpc_id            = "${module.vpc.vpc_id}"
   subnet_cidr_block = "${cidrsubnet("${var.vpc_cidr_block}","${var.subnet_size}",3)}"
   availability_zone = "${var.aws_region}${var.av_zone2}"
   tag_subnet_name   = "${var.aws_region}${var.av_zone2}-${module.vpc.vpc_tag_name}-ext-2"
   tag_subnet_type   = "external" 
}

# Create routing tables 
module "rtb-ext" {
   source       = "../../modules/rtb"
   vpc_id       = "${module.vpc.vpc_id}"
   #default_gw   = "${module.igw.igw_id}"
   tag_rtb_name = "${var.aws_region}-${module.vpc.vpc_tag_name}-rtb-ext"
   tag_rtb_type = "external"
}

#add default routes to route tables
module "rtb-ext-default-route" {
   source     = "../../modules/rtb-route"
   rtb_id     = "${module.rtb-ext.rtb_id}" 
   route_cidr = "0.0.0.0/0"
   gw_id      = "${module.igw.igw_id}"
   natgw_id   = ""
   peer_id    = ""
}

#associate RTBs to subnets
module "assoc-ext1" {
   source    = "../../modules/rtb-assoc"
   subnet_id = "${module.subnet-ext1.subnet_id}"
   rtb_id    = "${module.rtb-ext.rtb_id}" 
}
module "assoc-ext2" {
   source    = "../../modules/rtb-assoc"
   subnet_id = "${module.subnet-ext2.subnet_id}"
   rtb_id    = "${module.rtb-ext.rtb_id}" 
}

###### S3 bucket creation
#define S3 bucket
resource "aws_s3_bucket" "spinnaker" {
  bucket        = "armoryspinnaker01"
  force_destroy = true
}
output "s3-bucket-id" {
   value = "${aws_s3_bucket.spinnaker.id}"
}
output "s3-bucket-arn" {
   value = "${aws_s3_bucket.spinnaker.arn}"
}


