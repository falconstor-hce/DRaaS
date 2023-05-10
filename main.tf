resource "ibm_network_vlan" "test_vlan" {
  name            = var.vlan_name
  datacenter      = var.vlan_datacenter
  type            = var.vlan_type
}
data "ibm_network_vlan" "vlan" {
    name = ibm_network_vlan.test_vlan.name
}

# VTL tile Instance Creation 
data "ibm_pi_catalog_images" "catalog_images" {
  provider             = ibm.tile
  sap                  = true
  vtl                  = true
  pi_cloud_instance_id = local.pid
}

data "ibm_pi_images" "cloud_instance_images" {
  provider             = ibm.tile
  pi_cloud_instance_id = local.pid
}

data "ibm_pi_placement_groups" "cloud_instance_groups" {
  provider             = ibm.tile
  pi_cloud_instance_id = local.pid
}

resource "ibm_pi_key" "sshkeys" {
  provider             = ibm.tile
  pi_cloud_instance_id = local.pid
  pi_key_name          = var.vtl_SSHkey_name         
  pi_ssh_key           = var.vtl_public_key
}



resource "ibm_pi_network" "power_network_1" {
  provider             = ibm.tile
  pi_network_name      = var.vtl_network_name_1
  pi_cloud_instance_id = local.pid
  pi_network_type      = "vlan"
  pi_cidr              = var.vtl_cidr_1
  pi_gateway           = var.vtl_gateway_1
}

resource "ibm_pi_network" "power_network_2" {
  provider             = ibm.tile
  count = length(var.vtl_network_name_2) > 0 ? 1 : 0
  pi_network_name      = var.vtl_network_name_2
  pi_cloud_instance_id = local.pid
  pi_network_type      = "vlan"
  pi_cidr              = var.vtl_cidr_2
  pi_gateway           = var.vtl_gateway_2 
}

resource "ibm_pi_network" "power_network_3" {
  provider             = ibm.tile
  count = length(var.vtl_network_name_3) > 0 ? 1 : 0
  pi_network_name      = var.vtl_network_name_3
  pi_cloud_instance_id = local.pid
  pi_network_type      = "vlan"
  pi_cidr              = var.vtl_cidr_3
  pi_gateway           = var.vtl_gateway_3 
}

data "ibm_pi_network" "network_1" {
  provider             = ibm.tile
  pi_cloud_instance_id = local.pid
  pi_network_name      = ibm_pi_network.power_network_1.pi_network_name
}

data "ibm_pi_network" "network_2" {
  provider             = ibm.tile
  count = length(var.vtl_network_name_2) > 0 ? 1 : 0
  pi_cloud_instance_id = local.pid
  pi_network_name      = ibm_pi_network.power_network_2[0].pi_network_name
}

data "ibm_pi_network" "network_3" {
  provider             = ibm.tile
  count = length(var.vtl_network_name_3) > 0 ? 1 : 0
  pi_cloud_instance_id = local.pid
  pi_network_name      = ibm_pi_network.power_network_3[0].pi_network_name
}

locals {
  stock_image_name = "VTL-FalconStor-10_03-001"
  catalog_image = [for x in data.ibm_pi_catalog_images.catalog_images.images : x if x.name == local.stock_image_name]
  private_image = [for x in data.ibm_pi_images.cloud_instance_images.image_info : x if x.name == local.stock_image_name]
  private_image_id = length(local.private_image) > 0 ? local.private_image[0].id  : ""
  placement_group = [for x in data.ibm_pi_placement_groups.cloud_instance_groups.placement_groups : x if x.name == var.vtl_placement_group]
  placement_group_id = length(local.placement_group) > 0 ? local.placement_group[0].id : ""

  images_length              = length(var.powervs_image_names)
  split_images_index         = ceil(local.images_length / 3)
  catalog_images_to_import_1 = flatten([for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : [for image_name in slice(var.powervs_image_names, 0, local.split_images_index) : stock_image if stock_image.name == image_name]])
  catalog_images_to_import_2 = flatten([for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : [for image_name in slice(var.powervs_image_names, 1, local.split_images_index) : stock_image if stock_image.name == image_name]])
  catalog_images_to_import_3 = flatten([for stock_image in data.ibm_pi_catalog_images.catalog_images_ds.images : [for image_name in slice(var.powervs_image_names, local.split_images_index, local.images_length) : stock_image if stock_image.name == image_name]])
  split_images_1             = slice(var.powervs_image_names, 0, local.split_images_index)
  split_images_2             = slice(var.powervs_image_names, 1, local.split_images_index)
  split_images_3             = slice(var.powervs_image_names, local.split_images_index, local.images_length)
  
}



resource "ibm_pi_image" "stock_image_copy" {
  provider             = ibm.tile
  count = length(local.private_image_id) == 0 ? 1 : 0
  pi_image_name       = local.stock_image_name
  pi_image_id         = local.catalog_image[0].image_id
  pi_cloud_instance_id = local.pid
}


resource "ibm_pi_network" "public_network" {
  provider             = ibm.tile
  count = length(var.vtl_public_network_name) > 0 ? 1 : 0
  pi_network_name      = var.vtl_public_network_name
  pi_cloud_instance_id = local.pid
  pi_network_type      = "pub-vlan" 
}

data "ibm_pi_network" "public_network" {
  provider             = ibm.tile
  count = length(var.vtl_public_network_name) > 0 ? 1 : 0
  pi_cloud_instance_id = local.pid
  pi_network_name      = ibm_pi_network.public_network[0].pi_network_name
}

resource "ibm_pi_instance" "instance" {
  provider             = ibm.tile
  pi_cloud_instance_id = local.pid
  pi_memory            = var.vtl_memory
  pi_processors        = var.vtl_processors
  pi_instance_name     = var.vtl_instance_name
  pi_proc_type         = var.vtl_processor_type
  pi_image_id          = length(local.private_image_id) == 0 ? ibm_pi_image.stock_image_copy[0].image_id : local.private_image_id
  pi_key_pair_name     = ibm_pi_key.sshkeys.pi_key_name
  pi_sys_type          = var.vtl_sys_type
  pi_storage_type      = var.vtl_storage_type
  pi_health_status    = "WARNING"
  pi_storage_pool     = "Tier1-Flash-2"
  pi_placement_group_id = local.placement_group_id
  pi_license_repository_capacity = var.vtl_licensed_repository_capacity
  pi_volume_ids  = [data.ibm_pi_volume.index_volume.id,data.ibm_pi_volume.tape_volume.id,data.ibm_pi_volume.configuration_volume.id]
  dynamic "pi_network" {
    for_each = var.vtl_public_network_name == "" ? [] : [1]
    content {
      network_id = data.ibm_pi_network.public_network[0].id
    }
  }
  pi_network {
    network_id = data.ibm_pi_network.network_1.id
    ip_address = length(var.vtl_ip_address_1) > 0 ? var.vtl_ip_address_1 : ""
  }
  dynamic "pi_network" {
    for_each = var.vtl_network_name_2 == "" ? [] : [1]
    content {
      network_id = data.ibm_pi_network.network_2[0].id
      ip_address = length(var.vtl_ip_address_2) > 0 ? var.vtl_ip_address_2 : ""
    }
  }
  dynamic "pi_network" {
    for_each = var.vtl_network_name_3 == "" ? [] : [1]
    content {
      network_id = data.ibm_pi_network.network_3[0].id
      ip_address = length(var.vtl_ip_address_3) > 0 ? var.vtl_ip_address_3 : ""
    }
  }
}

resource "ibm_pi_volume" "index_volume"{
  pi_volume_size       = var.vtl_index_volume_size
  pi_volume_name       = "${var.vtl_instance_name}_index_volume"
  pi_volume_type       = var.vtl_storage_type
  pi_volume_shareable  = true
  pi_cloud_instance_id = local.pid
}

data "ibm_pi_volume" "index_volume" {
  pi_volume_name       = ibm_pi_volume.index_volume.pi_volume_name
  pi_cloud_instance_id = local.pid
}

resource "ibm_pi_volume" "tape_volume"{
  pi_volume_size       = var.vtl_tape_volume_size
  pi_volume_name       = "${var.vtl_instance_name}_tape_volume"
  pi_volume_type       = var.vtl_storage_type
  pi_volume_shareable  = true
  pi_cloud_instance_id = local.pid
}

data "ibm_pi_volume" "tape_volume" {
  pi_volume_name       = ibm_pi_volume.tape_volume.pi_volume_name
  pi_cloud_instance_id = local.pid
}

resource "ibm_pi_volume" "configuration_volume"{
  pi_volume_size       = var.vtl_configuration_volume_size
  pi_volume_name       = "${var.vtl_instance_name}_configuration_volume"
  pi_volume_type       = var.vtl_storage_type
  pi_volume_shareable  = true
  pi_cloud_instance_id = local.pid
}

data "ibm_pi_volume" "configuration_volume" {
  pi_volume_name       = ibm_pi_volume.configuration_volume.pi_volume_name
  pi_cloud_instance_id = local.pid
}



# Cos server creation proxy \ any other in classic
resource "ibm_compute_ssh_key" "proxy_ssh_key" {
    label      = var.proxy_SSHkey_name
    public_key = var.proxy_public_key
}

resource "ibm_compute_vm_instance" "proxy_server" {
  hostname                   = var.proxy_hostname
  domain                     = var.proxy_domain
  os_reference_code          = var.proxy_os
  datacenter                 = ibm_network_vlan.test_vlan.datacenter
  network_speed              = var.proxy_speed
  hourly_billing             = true
  private_network_only       = false
  cores                      = var.proxy_cores
  memory                     = var.proxy_memory
  disks                      = [25, 10, 20]
  user_metadata              = "${file("install_nginx.sh")}"
  local_disk                 = false
  private_vlan_id            = data.ibm_network_vlan.vlan.id
  ssh_key_ids                =  [ibm_compute_ssh_key.proxy_ssh_key.id]
}


#Cloud connection creation 
resource "ibm_pi_cloud_connection" "cloud_connection" {
  provider                   = ibm.tile
  pi_cloud_instance_id        = local.pid
  pi_cloud_connection_name    = var.cloud_connection_name
  pi_cloud_connection_classic_enabled = true
  pi_cloud_connection_networks = [data.ibm_pi_network.network_1.id]
  pi_cloud_connection_metered = true
  pi_cloud_connection_speed    = var.cloud_connection_speed
  pi_cloud_connection_gre_cidr = var.cloud_connection_gre_cidr
  pi_cloud_connection_gre_destination_address= var.juniper_router_IP4_address
}

#windows server creation in classic
resource "ibm_compute_ssh_key" "windows_ssh_key" {
    label      = var.windows_SSHkey_name
    public_key = var.windows_public_key
}

resource "ibm_compute_vm_instance" "Windows_server" {
  hostname                   = var.windows_hostname
  domain                     = var.windows_domain
  os_reference_code          = var.windows_os
  datacenter                 = "tok04"
  network_speed              = var.windows_speed
  hourly_billing             = true
  private_network_only       = false
  cores                      = var.windows_cores
  memory                     = var.windows_memory
  disks                      = [100, 10, 20]
  /*user_metadata              = <<EOF
#!/bin/bash
echo "Copying the console file  to the server"
winscp ../VTL-Console-10.03-11072-01.exe Administrator@"${ibm_compute_vm_instance.twc_terraform_sample.ipv4_address}":/Users/Administrator/Desktop
EOF*/
  local_disk                 = false
  ssh_key_ids                =  [ibm_compute_ssh_key.windows_ssh_key.id]
}


#IBMI instance creation in power

data "ibm_pi_catalog_images" "catalog_images_ds" {
  provider             = ibm.tile
  sap                  = true
  vtl                  = true
  pi_cloud_instance_id = local.pid
}

resource "ibm_pi_image" "import_images_1" {
  provider             = ibm.tile
  count                = length(local.split_images_1)
  pi_cloud_instance_id = local.pid
  pi_image_id          = local.catalog_images_to_import_1[count.index].image_id
  pi_image_name        = local.catalog_images_to_import_1[count.index].name

  timeouts {
    create = "9m"
  }
}

resource "ibm_pi_image" "import_images_2" {
  provider             = ibm.tile
  depends_on           = [ibm_pi_image.import_images_1]
  count                = length(local.split_images_2)
  pi_cloud_instance_id = local.pid
  pi_image_id          = local.catalog_images_to_import_2[count.index].image_id
  pi_image_name        = local.catalog_images_to_import_2[count.index].name

  timeouts {
    create = "9m"
  }
}

resource "ibm_pi_image" "import_images_3" {
  provider             = ibm.tile
  depends_on           = [ibm_pi_image.import_images_1]
  count                = length(local.split_images_3)
  pi_cloud_instance_id = local.pid
  pi_image_id          = local.catalog_images_to_import_3[count.index].image_id
  pi_image_name        = local.catalog_images_to_import_3[count.index].name

  timeouts {
    create = "9m"
  }
}


resource "ibm_pi_key" "linux_sshkey" {
  provider             = ibm.tile
  pi_key_name          = var.linux_sshkey_name
  pi_ssh_key           = var.linux_ssh_publickey
  pi_cloud_instance_id = local.pid
}

data "ibm_pi_network" "ds_network" {
  provider             = ibm.tile
  pi_network_name = "vtl-subnet"
  pi_cloud_instance_id = local.pid
}

resource "ibm_pi_instance" "linux-instance" {
    provider             = ibm.tile
    pi_memory             = var.linux_memory
    pi_processors         = var.linux_processors
    pi_instance_name      = var.linux_instance_name
    pi_proc_type          = var.linux_proc_type
    count                 = length(local.split_images_1)
    pi_image_id           = ibm_pi_image.import_images_1[count.index].image_id
    pi_key_pair_name      = ibm_pi_key.linux_sshkey.pi_key_name
    pi_sys_type           = var.linux_sys_type
    pi_cloud_instance_id  = local.pid
    pi_pin_policy         = "none"
    pi_health_status      = "WARNING"
    pi_storage_type       = var.linux_storage_type
    pi_network {
      network_id = data.ibm_pi_network.network_1.id
    }
}

resource "ibm_pi_key" "AIX_sshkey" {
  provider             = ibm.tile
  pi_key_name          = var.AIX_sshkey_name
  pi_ssh_key           = var.AIX_ssh_publickey
  pi_cloud_instance_id = local.pid
}

resource "ibm_pi_instance" "AIX-instance" {
    provider             = ibm.tile
    pi_memory             = var.AIX_memory
    pi_processors         = var.AIX_processors
    pi_instance_name      = var.AIX_instance_name
    pi_proc_type          = var.AIX_proc_type
    count                 = length(local.split_images_2)
    pi_image_id           = ibm_pi_image.import_images_2[count.index].image_id
    pi_key_pair_name      = ibm_pi_key.AIX_sshkey.pi_key_name
    pi_sys_type           = var.AIX_sys_type
    pi_cloud_instance_id  = local.pid
    pi_pin_policy         = "none"
    pi_health_status      = "WARNING"
    pi_storage_type       = var.AIX_storage_type
    pi_network {
      network_id = data.ibm_pi_network.network_1.id
    }
}


resource "ibm_pi_key" "IBMI_sshkey" {
  provider             = ibm.tile
  pi_key_name          = var.IBMI_sshkey_name
  pi_ssh_key           = var.IBMI_ssh_publickey
  pi_cloud_instance_id = local.pid
}

resource "ibm_pi_instance" "IBMI-instance" {
    provider             = ibm.tile
    pi_memory             = var.IBMI_memory
    pi_processors         = var.IBMI_processors
    pi_instance_name      = var.IBMI_instance_name
    pi_proc_type          = var.IBMI_proc_type
    count                 = length(local.split_images_3)
    pi_image_id           = ibm_pi_image.import_images_3[count.index].image_id
    pi_key_pair_name      = ibm_pi_key.IBMI_sshkey.pi_key_name
    pi_sys_type           = var.IBMI_sys_type
    pi_cloud_instance_id  = local.pid
    pi_pin_policy         = "none"
    pi_health_status      = "WARNING"
    pi_storage_type       = var.IBMI_storage_type
    pi_network {
      network_id = data.ibm_pi_network.network_1.id
    }
}



data "ibm_pi_instance" "ds_instance" {
  pi_instance_name     = ibm_pi_instance.instance.pi_instance_name
  pi_cloud_instance_id = local.pid
}







