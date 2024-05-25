output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip

}

output "instance_information" {
  value = aws_instance.web
}

output "web-url-preschool" {
  value = [for instance in aws_instance.this : "http://${instance.public_ip}/preschool"]

}

#output "web-url-clinic" {
 # value = [for instance in aws_instance.this : "http://${instance.public_ip}/clinic"]

#}