output "project_name" {
   description = "Name of Project"
   value       = var.name
}

output "project_tags" {
    description = "Tags to apply to resources in project"
    value = var.tags

}