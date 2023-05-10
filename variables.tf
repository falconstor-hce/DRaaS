#variables that coustmer needs to provide
variable "region" {
  type        = string
  default     = ""
  description = "classic region for example 'jp-tok'"
}

variable "zone" {
  type        = string
  default     = ""
  description = "classic zone for eample  'jp-tok-4' "
}

variable "ibmcloud_api_key" {
  type        = string
  default     = ""
}

variable "iaas_classic_username" {
  type        = string
  default     = ""
}

variable "iaas_classic_api_key" {
  type        = string
  default     = ""
}

variable "vtl_public_key" {
  type        = string
  default     = ""
  description = "VTL public key for SSH key creation"
}

variable "vtl_crn" {
  type        = string
  default     = ""
}

variable "vtl_network_name_1" {
  type        = string
  default     = "back-up"
  description = "First network ID or name to assign to the VTL instance"
}

variable "vtl_cidr_1" {
  type        = string
  default     = "192.168.2.0/24"
  description = "First network IP addresse range"
}

variable "vtl_gateway_1" {
  type        = string
  default     = "192.168.2.1"
  description = "First network gateway IP address"
}

variable "vtl_index_volume_size" {
  type        = number
  default     = 20
  description = "block-storage-volume maximum size of the volume in 2000GB, it will fail if we exceed the size"
}

variable "vtl_tape_volume_size" {
  type        = number
  default     = 20
  description = "tape-storage-volume maximum size of the volume in 2000GB, it will fail if we exceed the size"
}

variable "vtl_configuration_volume_size" {
  type        = number
  default     =20
  description = "configuration-storage-volume maximum size of the volume in 2000GB, it will fail if we exceed the size"
}

variable "proxy_public_key" {
  type        = string
  default     = ""
  description = "Proxy server public key ffor SSH key creation"
}

variable "cloud_connection_speed" {
  type        = number
  default     = 500
  description = "Cloud connection speed in Mb/s"
}

variable "cloud_connection_gre_cidr"{
  type        = string
  default     = ""
  description = "cloud_connection_gre_cidr"

}

variable "juniper_router_IP4_address"{
  type        = string
  default     = ""
  description = "juniper_router_IP4_address"

}

variable "windows_public_key" {
  type        = string
  default     = ""
  description = "windows server public key ffor SSH key creation"
}

variable "IBMI_ssh_publickey" {
  type        = string
  default     = ""
  description = "IBMI_ssh_publickey"
}

variable "AIX_ssh_publickey" {
  type        = string
  default     = ""
  description = "AIX_ssh_publickey"
}

variable "linux_ssh_publickey" {
  type        = string
  default     = ""
  description = "linux_ssh_publickey"
}

#optional/default values variables

variable "vlan_name" {
  type        = string
  default     = "FS_DRaas_vlan_name"
  description = "VLAN name"
}

variable "vlan_datacenter" {
  type        = string
  default     = "tok04"
  description = "VLAN datacenter"
}

variable "vlan_type" {
  type        = string
  default     = "PRIVATE"
  description = "VLAN type: 'PRIVATE', 'PUBLIC'"
}

variable "vtl_SSHkey_name" {
  type        = string
  default     = "vtl_sshkey"
  description = "VTL SSH key name"
}

variable "vtl_instance_name" {
  type        = string
  default     = "FS_DRaaS_vtl_instance"
  description = "VTL instance name"
}

variable "vtl_memory" {
  type        = number
  default     = 18
  description = " VTL memory amount in GB; it should be >= 16 + (2 * licensed_repository_capacity)"
}

variable "vtl_processors" {
  type        = number
  default     = 2
  description = "Number of CPU cores to allocate for VTL instance"
}

variable "vtl_processor_type" {
  type        = string
  default     = "shared"
  description = "VTL processor type: 'shared', 'capped', or 'dedicated'"
}

variable "vtl_sys_type" {
  type        = string
  default     = "s922"
  description = "Type of system on which to create the VTL instance: 's922', 'e880', 'e980', 'e1080', or 's1022'"
}

variable "vtl_storage_type" {
  type        = string
  default     = "tier3"
  description = "Type of storage tier to assign to the VTL instance based on required performance: 'tier1' or 'tier3'"
}

variable "vtl_licensed_repository_capacity" {
  type        = number
  default     = 1
  description = "VTL licensed repository capacity in TB"
}

variable "vtl_public_network_name" {
  type        = string
  default     = ""
  description = "First network ID or name to assign to the VTL instance"
}

variable "vtl_public_cidr" {
  type        = string
  default     = ""
  description = "First network IP addresse range"
}

variable "vtl_public_gateway" {
  type        = string
  default     = ""
  description = "First network gateway IP address"
}

variable "vtl_network_name_2" {
  type        = string
  default     = ""
  description = "Second network ID or name to assign to the VTL instance"
}

variable "vtl_cidr_2" {
  type        = string
  default     = ""
  description = "Second network IP addresse range"
}

variable "vtl_gateway_2" {
  type        = string
  default     = ""
  description = "Second network gateway IP address"
}

variable "vtl_network_name_3" {
  type        = string
  default     = ""
  description = "Third network ID or name to assign to the VTL instance"
}

variable "vtl_cidr_3" {
  type        = string
  default     = ""
  description = "Third network IP addresse range"
}

variable "vtl_gateway_3" {
  type        = string
  default     = ""
  description = "Third network gateway IP address"
}

variable "vtl_placement_group" {
  type        = string
  default     = ""
  description = "Server group name where the VTL instance will be placed, as defined for the selected Power Systems Virtual Server CRN"
}
variable "vtl_affinity_policy" {
  type        = string
  default     =  "anti-affinity"
  description = "Storage anti-affinity policy to use for placemant of the VTL volume if PVM instance IDs are sepcified"
}

variable "vtl_ip_address_1" {
  type        = string
  default     = "192.168.2.5"
  description = "Specific IP address to assign to the first network rather than automatic assignment within the IP range"
}

variable "vtl_ip_address_2" {
  type        = string
  default     = ""
  description = "Specific IP address to assign to the second network rather than automatic assignment within the IP range"
}

variable "vtl_ip_address_3" {
  type        = string
  default     = ""
  description = "Specific IP address to assign to the third network rather than automatic assignment within the IP range"
}

variable "proxy_SSHkey_name" {
  type        = string
  default     = "FS_DRaaS_proxy_SSHkey"
  description = "Name of the SSH key for the proxy server"

}

variable "proxy_hostname" {
  type        = string
  default     = "FS.DRaaS.proxy.hostname"
  description = "Proxy server hostname"
}

variable "proxy_domain" {
  type        = string
  default     = "FS.DRaaS.proxy.domain"
  description = "Proxy server domain name"
}

variable "proxy_os" {
  type        = string
  default     = "CENTOS_7_64"
  description = "Proxy server OS reference code"
}

variable "proxy_speed" {
  type        = number
  default     = 100
  description = "Proxy server network speed in Mb/s for the instance's network components"
}

variable "proxy_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores to allocate for the proxy server"
}

variable "proxy_memory" {
  type        = number
  default     = 4096
  description = "Proxy server memory amount in MB"
}

variable "cloud_connection_name" {
  type        = string
  default     = "FS_DRaaS_cloud_connection"
  description = "The name of the Power direct link to Classic using Generic Routing Encapsulation (GRE) tunnel"
}

variable "windows_SSHkey_name" {
  type        = string
  default     = "FS_DRaaS_windows_SSHkey"
  description = "Name of the SSH key for the windows server"

}

variable "windows_hostname" {
  type        = string
  default     = "FS.DRaaS.windows.hostname"
  description = "windows server hostname"
}

variable "windows_domain" {
  type        = string
  default     = "FS.DRaaS.windows.domain"
  description = "windows server domain name"
}

variable "windows_os" {
  type        = string
  default     = "WIN_2022-STD_64"
  description = "windows server OS reference code"
}

variable "windows_speed" {
  type        = number
  default     = 100
  description = "windows server network speed in Mb/s for the instance's network components"
}

variable "windows_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores to allocate for the windows server"
}

variable "windows_memory" {
  type        = number
  default     = 4096
  description = "windows server memory amount in MB"
}


variable "IBMI_sshkey_name" {
  type        = string
  default     = "FS_IBMI_sshkey"
  description = "IBMI_sshkey_name"
}

variable "IBMI_memory" {
  type        = number
  default     = "2"
  description = "IBMI_memory"
}

variable "IBMI_processors" {
  type        = number
  default     = "0.25"
  description = "IBMI_processors"
}

variable "IBMI_instance_name" {
  type        = string
  default     = "FS_DraaS_IBMI_instance"
  description = "IBMI_instance_name"
}

variable "IBMI_proc_type" {
  type        = string
  default     = "shared"
  description = "IBMI_proc_type"
}

variable "IBMI_sys_type" {
  type        = string
  default     = "s922"
  description = "IBMI_sys_type"
}

variable "IBMI_storage_type" {
  type        = string
  default     = "tier3"
  description = "Type of storage tier to assign to the VTL instance based on required performance: 'tier1' or 'tier3'"
}

variable "powervs_image_names" {
  description = "List of Images to be imported into cloud account from catalog images."
  type        = list(string)
  default = [ "RHEL8-SP6","7200-05-05","IBMi-72-09-2924-8" ]
}


variable "AIX_sshkey_name" {
  type        = string
  default     = "fs_AIX_sshkey"
  description = "AIX_sshkey_name"
}



variable "AIX_memory" {
  type        = number
  default     = "2"
  description = "AIX_memory"
}

variable "AIX_processors" {
  type        = number
  default     = "0.25"
  description = "AIX_processors"
}

variable "AIX_instance_name" {
  type        = string
  default     = "fs_DraaS_AIX_instance"
  description = "AIX_instance_name"
}

variable "AIX_proc_type" {
  type        = string
  default     = "shared"
  description = "AIX_proc_type"
}

variable "AIX_sys_type" {
  type        = string
  default     = "s922"
  description = "AIX_sys_type"
}

variable "AIX_storage_type" {
  type        = string
  default     = "tier3"
  description = "Type of storage tier to assign to the VTL instance based on required performance: 'tier1' or 'tier3'"
}

variable "linux_sshkey_name" {
  type        = string
  default     = "fs_linux_sshkey"
  description = "linux_sshkey_name"
}



variable "linux_memory" {
  type        = number
  default     = "2"
  description = "linux_memory"
}

variable "linux_processors" {
  type        = number
  default     = "0.25"
  description = "linux_processors"
}

variable "linux_instance_name" {
  type        = string
  default     = "fs_DraaS_linux_instance"
  description = "linux_instance_name"
}

variable "linux_proc_type" {
  type        = string
  default     = "shared"
  description = "linux_proc_type"
}

variable "linux_sys_type" {
  type        = string
  default     = "s922"
  description = "linux_sys_type"
}

variable "linux_storage_type" {
  type        = string
  default     = "tier3"
  description = "Type of storage tier to assign to the VTL instance based on required performance: 'tier1' or 'tier3'"
}