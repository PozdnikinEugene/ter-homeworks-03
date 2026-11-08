resource "yandex_compute_disk" "additional" {
  count = var.disk_storage_setings.storage-disk.count
  name  = "${var.disk_storage_setings.storage-disk.name}-${count.index + 1}"
  type  = var.disk_storage_setings.storage-disk.type
  size  = var.disk_storage_setings.storage-disk.size
}

resource "yandex_compute_instance" "storage" {


  name        = var.vms_setings.storage.name
  hostname    = var.vms_setings.storage.name
  platform_id = var.vms_setings.storage.platform_id

  resources {
    cores         = var.vms_resources.storage.cores
    memory        = var.vms_resources.storage.memory
    core_fraction = var.vms_resources.storage.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vms_setings.storage.type
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = var.vms_setings.storage.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vm_metadata

  # Использование dynamic + for_each для подключения 3 дисков
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional[*].id

    content {
      disk_id = secondary_disk.value
    }
  }
}