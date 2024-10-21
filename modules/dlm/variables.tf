variable "dlm_schedule_name" {
    description = "Name of the DLM schedule"
    type        = string
}

variable "dlm_interval" {
    description = "Interval for the DLM schedule"
    type        = number
}

variable "dlm_interval_unit" {
    description = "Unit for the DLM schedule interval"
    type        = string
}

variable "dlm_retain_rule_count" {
    description = "Number of snapshots to retain"
    type        = number
}

variable "dlm_times" {
    description = "Time to take the snapshot"
    type        = string
}