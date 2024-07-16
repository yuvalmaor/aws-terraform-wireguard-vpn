
tags = {
  "bootcamp"        = "20",
  "Owner"           = "Yuval.Maor",
  "expiration_date" = "24-07-25"
}

env = "protfolio"

region = "ap-south-1"

availability_zones = ["ap-south-1a", "ap-south-1b"]
cidr_blocks        = ["10.0.1.0/24", "10.0.2.0/24"]
#private_cidr_blocks        = ["10.0.5.0/24", "10.0.6.0/24"]

instance_type = "t2.micro"
# min_size      = 3
# desired_size  = 3
# max_size      = 3
num_of_subnets = 2
# num_route_table = 2

# argo_cd_version = "7.0.0"
# argo_namespace  = "argo"
