resource "yandex_compute_instance" "web" {
  count = var.vms_setings.web.count

  name        = "${var.vms_setings.web.name}-${count.index + 1}"
  hostname    = "${var.vms_setings.web.name}-${count.index + 1}"
  platform_id = var.vms_setings.web.platform_id

  depends_on = [yandex_compute_instance.db] # Создание после db 

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vms_setings.web.type
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vms_setings.web.nat
    security_group_ids = [yandex_vpc_security_group.example.id] # Добавляется группа безопасности
  }

  metadata = local.vm_metadata
}
