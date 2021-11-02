variable "script_path" {
  description = "Script Configuration Path"
  default = "scripts/runit.sh"
  type = string
}

# Define tags as a Map, it is suitable for this case
variable "vars" {
  description = "A mapping of variables to assign to script"
  type        = map(string)
  default     = {}
  # default = {
  #   DEVICE = "/dev/xvdh"
  # }
}
