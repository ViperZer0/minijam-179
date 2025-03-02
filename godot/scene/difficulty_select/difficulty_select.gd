extends MarginContainer

@export_file("*.tscn") var main_scene_path: String = ""
@export_file("*.tscn") var back_scene_path: String = ""
@export_file("*.tscn") var tutorial_scene_path: String = ""

@export var easy_difficulty: Difficulty
@export var medium_difficulty: Difficulty
@export var hard_difficulty: Difficulty

@onready var main_scene: Main = load(main_scene_path).instantiate()
@onready var back_scene: Control = load(back_scene_path).instantiate()
@onready var tutorial_scene: Control = load(tutorial_scene_path).instantiate()
@onready var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")
@onready var easy_button_label: Label = %EasyButtonLabel
@onready var medium_button_label: Label = %MediumButtonLabel
@onready var hard_button_label: Label = %HardButtonLabel

func _ready() -> void:
	# Set the button labels with the difficulty harmonics.
	# We're loading this shit dynamically baby
	easy_button_label.text = _difficulty_into_string_range(easy_difficulty) + " " + easy_button_label.text
	medium_button_label.text = _difficulty_into_string_range(medium_difficulty) + " " + medium_button_label.text
	hard_button_label.text = _difficulty_into_string_range(hard_difficulty) + " " + hard_button_label.text

func _on_tutorial_button_pressed():
	scene_transition_service.zoom_in(self, tutorial_scene)

func _on_easy_button_pressed():
	main_scene.difficulty = easy_difficulty
	scene_transition_service.zoom_in(self, main_scene)

func _on_medium_button_pressed():
	main_scene.difficulty = medium_difficulty
	scene_transition_service.zoom_in(self, main_scene)

func _on_hard_button_pressed():
	main_scene.difficulty = hard_difficulty
	scene_transition_service.zoom_in(self, main_scene)

func _on_back_button_pressed():
	scene_transition_service.zoom_out(self, back_scene)

## Returns the range of a difficulty's harmonics.
## I.e a difficulty with a minimum of 2 harmonics and a maximum of 5
## would return the string "2-5"
func _difficulty_into_string_range(difficulty: Difficulty) -> String:
	return str(difficulty.min_num_harmonics) + "-" + str(difficulty.max_num_harmonics)

