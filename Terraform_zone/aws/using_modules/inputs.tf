variable "instance_name" {
  type        = list(string)
  description = "instance names"
  default     = ["web", "web-1", "web-2"]
}