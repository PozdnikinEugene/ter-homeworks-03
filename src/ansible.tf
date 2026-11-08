resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    web_vms    = yandex_compute_instance.web
    db_vms     = yandex_compute_instance.db
    storage_vm = [yandex_compute_instance.storage]
  })
  filename = "${path.module}/inventory.ini"
}