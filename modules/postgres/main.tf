
locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = var.replicas
    ports                = var.ports
    enable_service_links = false

    containers = [
      {
        name  = "postgres"
        image = var.image

        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "POSTGRES_USER"
            value = var.POSTGRES_USER
          },
          {
            name  = "POSTGRES_PASSWORD"
            value = var.POSTGRES_PASSWORD
          },
          {
            name  = "POSTGRES_DB"
            value = var.POSTGRES_DB
          },
          {
            name  = "PGDATA"
            value = "/data/$(POD_NAME)"
          },
        ], var.env)

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/data"
            sub_path   = var.name
          },
          {
            name       = "shm"
            mount_path = "/dev/shm"
          },
        ]
      },
    ]

    volumes = [
      {
        name = "shm"

        empty_dir = {
          "medium" = "Memory"
        }
      },
    ]

    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class
        access_modes       = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}

module "statefulset-service" {
  source     = "../../archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}
