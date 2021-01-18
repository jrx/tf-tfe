output "public_subnets" {
  value = data.terraform_remote_state.vpc.outputs.aws_public_subnets
}

output "azs" {
  value = data.terraform_remote_state.vpc.outputs.aws_azs
}

output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.aws_vpc_id
}

output "vpc_security_group_default" {
  value = [aws_security_group.default.id]
}

output "vpc_security_group_db" {
  value = [aws_security_group.db_access.id]
}

output "vpc_security_group_redis" {
  value = [aws_security_group.redis_access.id]
}