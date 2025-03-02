extends MarginContainer
class_name About

@export_file("*.tscn") var back_scene_path: String = ""
@onready var back_scene: PackedScene = load(back_scene_path)

func _on_label_meta_clicked(meta:Variant):
	OS.shell_open(str(meta))

func _on_back_button_pressed():
	var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")
	var back_scene_instance = back_scene.instantiate()
	scene_transition_service.zoom_out(self, back_scene_instance)

