output "vtl_instance" {
  value       = [data.ibm_pi_instance.ds_instance.pi_instance_name]
  description = "Landing zone configuration"
}