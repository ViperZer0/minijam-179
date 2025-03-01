extends MarginContainer

@export_file("*.tscn") var main_scene_path: String = ""
@onready var main_scene: Control = load(main_scene_path).instantiate()
@onready var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")

func _on_sound_button_pressed():
	scene_transition_service.zoom_in(self, main_scene)


