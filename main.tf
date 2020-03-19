resource "aws_codebuild_project" "cb_project" {
  name           = var.name
  badge_enabled  = var.badge_enabled
  build_timeout  = var.build_timeout
  description    = var.description
  encryption_key = var.encryption_key
  service_role   = aws_iam_role.service_role.arn
  queued_timeout = var.queued_timeout

  # Artifacts
  dynamic "artifacts" {
    for_each = [local.artifacts]
    content {
      type                   = lookup(artifacts.value, "type")
      artifact_identifier    = lookup(artifacts.value, "artifact_identifier")
      encryption_disabled    = lookup(artifacts.value, "encryption_disabled")
      override_artifact_name = lookup(artifacts.value, "override_artifact_name")
      location               = lookup(artifacts.value, "location")
      name                   = lookup(artifacts.value, "name")
      namespace_type         = lookup(artifacts.value, "namespace_type")
      packaging              = lookup(artifacts.value, "packaging")
      path                   = lookup(artifacts.value, "path")
    }
  }

  # Cache
  dynamic "cache" {
    for_each = [local.cache]
    content {
      type     = lookup(cache.value, "type")
      location = lookup(cache.value, "location")
      modes    = lookup(cache.value, "modes")
    }
  }

  # Environment
  dynamic "environment" {
    for_each = [local.environment]
    content {
      compuer_type                = lookup(environment.value, "computer_type")
      image                       = lookup(environment.value, "image")
      type                        = lookup(environment.value, "type")
      image_pull_credentials_type = lookup(environment.value, "type")
      privileged_mode             = lookup(environment.value, "privileged_mode")
      certificate                 = lookup(environment.value, "certificate")
      registry_credential         = lookup(environment.value, "registry_credential")

      # Environment variables
      dynamic "environment_variable" {
        for_each = length(lookup(environment.value, "environment_variables"), {}) == 0 ? [] : [lookup(environment.value, "environment_variables", {})]
        content {
          name  = environment_variable.value.name
          value = environment_variable.value.value
        }
      }
    }
  }
}

locals {

  # Artifacts
  # If no artifacts block is provided, build artifacts config using the default values
  artifacts = {
    type                   = lookup(var.artifacts, "type", null) == null ? var.artifacts_type : lookup(var.artifacts, "type")
    artifact_identifier    = lookup(var.artifacts, "artifact_identifier", null) == null ? var.artifacts_artifact_identifier : lookup(var.artifacts, "artifact_identifier")
    encryption_disabled    = lookup(var.artifacts, "encryption_disabled", null) == null ? var.artifacts_encryption_disabled : lookup(var.artifacts, "encryption_disabled")
    override_artifact_name = lookup(var.artifacts, "override_artifact_name", null) == null ? var.artifacts_override_artifact_name : lookup(var.artifacts, "override_artifact_name")
    location               = lookup(var.artifacts, "location", null) == null ? var.artifacts_location : lookup(var.artifacts, "location")
    name                   = lookup(var.artifacts, "name", null) == null ? var.artifacts_name : lookup(var.artifacts, "name")
    namespace_type         = lookup(var.artifacts, "namespace_type", null) == null ? var.artifacts_namespace_type : lookup(var.artifacts, "namespace_type")
    packaging              = lookup(var.artifacts, "packaging", null) == null ? var.artifacts_packaging : lookup(var.artifacts, "packaging")
    path                   = lookup(var.artifacts, "path", null) == null ? var.artifacts_path : lookup(var.artifacts, "path")
  }

  # Cache
  # If no cache block is provided, build cache config using the default values
  cache = {
    type     = lookup(var.cache, "type", null) == null ? var.cache_type : lookup(var.cache, "type")
    location = lookup(var.cache, "location", null) == null ? var.cache_location : lookup(var.cache, "location")
    modes    = lookup(var.cache, "modes", null) == null ? var.cache_modes : lookup(var.cache, "modes")
  }

  # Environmet
  # If no enviroment block is provided, build environment block using the default values
  environment = {
    computer_type = lookup(var.environment, "computer_type", null) == null ? var.environment_computer_type : lookup(var.environment, "computer_type")
    image         = lookup(var.environment, "image", null) == null ? var.environment_image : lookup(var.environment, "image")
  }

}