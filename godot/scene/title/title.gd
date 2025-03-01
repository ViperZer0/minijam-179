extends MarginContainer

@export_file("*.tscn") var main_scene_path: String = ""
@onready var main_scene: Control = load(main_scene_path).instantiate()
@onready var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")
@onready var quit_button: SoundButton = %QuitButton

func _ready() -> void:
	# Hide the quit button overlay on the web.
	# I think you can close browser games? but idk, maybe that doesn't make much sense
	if OS.get_name() == "Web":
		quit_button.hide()

func _on_sound_button_pressed():
	scene_transition_service.zoom_in(self, main_scene)

func _on_quit_button_pressed():
	get_tree().quit()


