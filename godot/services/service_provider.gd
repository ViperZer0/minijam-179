extends Node

static var instance: ServiceProvider
var services: Dictionary

func _ready() -> void:
	services = Dictionary()
	var services_to_load = _get_service_children()
	for service in services_to_load:
		# Load each service, reference it by its saved name
		services[service.name] = service

func get_service(service_name: String) -> Node:
	return services[service_name]

func _get_service_children() -> Array[Node]:
	return get_node("%Services").get_children()
