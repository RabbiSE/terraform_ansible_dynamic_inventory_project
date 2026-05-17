# Groups instances by OS family, then passes each group to the template.
# The template just loops and prints — no filtering logic needed there.

locals {
  inventory = { for name, instance in aws_instance.vm_instances : name => {
    public_ip = instance.public_ip
    user      = var.instances[name].user
    os_family = var.instances[name].os_family
  }}

  ubuntu_hosts = { for name, instance in local.inventory : name => instance if instance.os_family == "ubuntu" }
  redhat_hosts = { for name, instance in local.inventory : name => instance if instance.os_family == "redhat" }
  amazon_hosts = { for name, instance in local.inventory : name => instance if instance.os_family == "amazon" }
  master_hosts = { for name, instance in local.inventory : name => instance if can(regex("master", name)) }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tpl", {
    ssh_key_path = var.ssh_key_path
    ubuntu       = local.ubuntu_hosts
    redhat       = local.redhat_hosts
    amazon       = local.amazon_hosts
    master       = local.master_hosts
  })

  filename        = "${path.module}/../inventories/hosts.ini"
  file_permission = "0644"
}