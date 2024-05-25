output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip

}

output "instance_information" {
  value = aws_instance.web
}
