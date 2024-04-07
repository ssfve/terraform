output "ec2_public_id" {
  value = module.myapp-server.webserver.public_ip
}