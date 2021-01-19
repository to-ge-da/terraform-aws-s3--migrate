# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "create_s3" {
  description = "Controls if the s3 bucket should be created."
  type        = bool
  default     = true
}

variable "bucket" {
  description = "The name of the bucket."
  type        = string
}

variable "acl" {
  description = "The canned ACL to apply."
  type        = string
  default     = "private"
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = true
}

variable "versioning" {
  description = "A state of versioning."
  type        = bool
}

variable "website" {
  description = "A website object."
  type        = list(map(string))
  default = [
    {
      index   = "index.html"
      error   = "index.html"
      routing = <<EOF
      [{
          "Condition": {
              "KeyPrefixEquals": "/"
          },
          "Redirect": {
              "ReplaceKeyWith": "index.html"
          }
      }]
      EOF
    }
  ]
}

variable "sse_algorithm" {
  description = "A configuration of server-side encryption configuration."
  type        = string
  default     = "AES256"
}
