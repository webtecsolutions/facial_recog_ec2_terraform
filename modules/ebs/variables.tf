variable "ec2_instance_id" {
  description = "The ID of the EC2 instance to attach the EBS volume to"
  type        = string
  
}

variable "aws_availability_zone" {
  description = "The availability zone of the EBS volume"
  type        = string
}
variable "ebs_device_name" {
  description = "The device name to attach the EBS volume to"
  type        = string
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume"
  type        = number
}

variable "ebs_snapshot_id" {
  description = "The ID of the EBS snapshot to restore the volume from"
  type        = string
}