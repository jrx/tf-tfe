output "public_subnets" {
  value = module.vpc.public_subnets
}

output "azs" {
  value = module.vpc.azs
}

output "vpc_security_group_default" {
  value = [aws_security_group.default.id]
}

output "vpc_security_group_db" {
  value = [aws_security_group.db_access.id]
}