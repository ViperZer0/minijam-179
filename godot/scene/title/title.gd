extends MarginContainer

@export_file("*.tscn") var main_scene_path: String = ""
@onready var main_scene: PackedScene = load(main_scene_path)
@onready var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")

func _on_sound_button_pressed():
	scene_transition_service.zoom_in(self, main_scene)


