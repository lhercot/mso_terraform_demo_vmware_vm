terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}

data "vsphere_datacenter" "dc" {
  name = var.vmware_dc
}

data "vsphere_datastore" "datastore" {
  name          = var.vmware_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vmware_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = var.vmware_dvs
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vmware_portgroup
  datacenter_id = data.vsphere_datacenter.dc.id
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
}

data "vsphere_virtual_machine" "template" {
  name          = "db-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone = true
    customize {
      linux_options {
        host_name = var.vm_name
        domain    = "cisco.com"
      }

      network_interface {
        ipv4_address = var.db_ip_address
        ipv4_netmask = 24
      }

      ipv4_gateway = var.db_gateway
    }
  }
}