variable "namespace" {
  type        = string
  description = "The name of the namespace to deploy services to"
}

variable "chart_name" {
  type        = string
  description = "The chart path of the application"
}

variable "name" {
  type        = string
  description = "The chart name of the application"
}