# to read the value of some output, simply create them in the root level and run terraform refresh, 
# we then obtain Outputs:
# load_balancefr_endpoint = "james-loadbalancer-1462265700.ap-northeast-1.elb.amazonaws.com"
# or simply run terraform output

# use terraform output -json | jq 
# to view sensitive data

output "load_balancefr_endpoint" {
  value = module.loadbalancing.lb_endpoint
}

output "instance_ip" {
  value     = { for inst in nonsensitive(module.compute.instance) : inst.tags["Name"] => inst.public_ip }
  sensitive = true
}