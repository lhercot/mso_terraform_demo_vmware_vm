
variable "vmware_dc" {
  type = string
  default = "hx-dmz"
  description = "The VMware Data Center name"
}

variable "vmware_datastore" {
  type = string
  default = "HX_DMZ_VMs"
  description = "The VMware datastore to use for the VM"
}

variable "vmware_cluster" {
  type = string
  default = "hx-dmz"
  description = "The VMware cluster name"
}

variable "vmware_dvs" {
  type = string
  default = "VMware-VMM"
  description = "The VMware cluster name"
}

variable "vmware_portgroup" {
  type = string
  default = "WoS|ANP-Financial|DB"
  description = "The VMware port group name"
}

variable "db_ip_address" {
  type = string
  default = "10.101.10.11"
  description = "The IP address of the DB VM to point to"
}

variable "db_gateway" {
  type = string
  default = "10.101.10.254"
  description = "The IP address of the gateway of the DB VM"
}

variable "vm_name" {
  type = string
  default = "example"
  description = "The VM name"
}