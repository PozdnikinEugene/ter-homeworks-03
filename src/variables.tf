###cloud vars
/*variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}*/

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

# Images

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS image"
}

# Для each_vm 
variable "each_vm" {
  type = list(object({
    vm_name       = string
    vm_hostname   = string
    platform_id   = string
    cpu           = number
    ram           = number
    core_fraction = number
    disk_volume   = number
    disk_type     = string
    preemptible   = bool
    nat           = bool

  }))
  description = "Параметры ВМ БД: main и replica"
  default = [
    {
      vm_name       = "main"
      vm_hostname   = "main"
      platform_id   = "standard-v2"
      cpu           = 2
      ram           = 1
      core_fraction = 5
      disk_volume   = 5
      disk_type     = "network-ssd"
      preemptible   = true
      nat           = true

    },
    {
      vm_name       = "replica"
      vm_hostname   = "replica"
      platform_id   = "standard-v2"
      cpu           = 2
      ram           = 1
      core_fraction = 5
      disk_volume   = 5
      disk_type     = "network-ssd"
      preemptible   = true
      nat           = true
    }
  ]
}

# Для ВМ count и Storage 

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  description = "Ресурсы ВМ (cores, memory, core_fraction) для каждой машины"
  default = {
    web = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
    storage = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
  }
}

# Общие переменные web и storage

variable "vms_setings" {
  type = map(object({
    name        = string #
    platform_id = string # 
    type        = bool   # preemptible
    nat         = bool   # Внешний ip-adress 
    count       = number # Количество ВМ 

  }))
  description = "Настройки ВМ"
  default = {
    web = {
      name        = "web"
      platform_id = "standard-v2"
      type        = true
      nat         = true
      count       = 2
    }
    storage = {
      name        = "storage"
      platform_id = "standard-v2"
      type        = true
      nat         = true
      count       = 0
    }
  }
}

# Настройки дисков
variable "disk_storage_setings" {
  type = map(object({
    count = number
    name  = string
    type  = string
    size  = number
  }))

  description = "Настройки дисков"
  default = {
    storage-disk = {
      count = 3
      name  = "storage-disk"
      type  = "network-hdd"
      size  = 1
    }
  }
}