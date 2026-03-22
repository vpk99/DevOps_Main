variable "bucket_name_set" {
  description = "set of name for bucket"
  type = set(string)
  default = [ "vinayak-1", "vinayak-2", "vinayak-3" ]
}