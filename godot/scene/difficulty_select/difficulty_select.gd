extends MarginContainer

@export_file("*.tscn") var main_scene_path: String = ""
@export_file("*.tscn") var back_scene_path: String = ""

@export_group("Easy Parameters")
@export var easy_min_num_harmonics: int = 2
@export var easy_max_num_harmonics: int = 3
@export var easy_error_margin: float = 0.05

@export_group("Medium Parameters")
@export var medium_min_num_harmonics: int = 3
@export var medium_max_num_harmonics: int = 4
@export var medium_error_margin: float = 0.03

@export_group("Hard Parameters")
@export var hard_min_num_harmonics: int = 3
@export var hard_max_num_harmonics: int = 5
@export var hard_error_margin: float = 0.01

@onready var main_scene: Main = load(main_scene_path).instantiate()
@onready var back_scene: Control = load(back_scene_path).instantiate()
@onready var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")

func _on_tutorial_button_pressed():
	pass # Replace with function body.

func _on_easy_button_pressed():
	main_scene.num_target_harmonics = randi_range(easy_min_num_harmonics, easy_max_num_harmonics)
	main_scene.error_threshold = easy_error_margin
	scene_transition_service.zoom_in(self, main_scene)

func _on_medium_button_pressed():
	main_scene.num_target_harmonics = randi_range(medium_min_num_harmonics, medium_max_num_harmonics)
	main_scene.error_threshold = medium_error_margin
	scene_transition_service.zoom_in(self, main_scene)

func _on_hard_button_pressed():
	main_scene.num_target_harmonics = randi_range(hard_min_num_harmonics, hard_max_num_harmonics)
	main_scene.error_threshold = hard_error_margin
	scene_transition_service.zoom_in(self, main_scene)

func _on_back_button_pressed():
	scene_transition_service.zoom_out(self, back_scene)
