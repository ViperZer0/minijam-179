extends Control
class_name WinTransition

@export var merge_amount: float = 0.0
@export var main_transparency: float:
	get:
		if main:
			return main.modulate.a
		else:
			# Idk??
			return 0.0
	set(value):
		if main:
			main.modulate.a = value

@export var main: Control

@export_file("*.tscn") var main_scene_path: String = ""
@onready var main_scene: PackedScene = load(main_scene_path)

@export_file("*.tscn") var difficulty_scene_path: String = ""
@onready var difficulty_scene: PackedScene = load(difficulty_scene_path)

@onready var random_tone_visualizer: AudioVisualizer = %RandomToneVisualizer
@onready var user_tone_visualizer: AudioVisualizer = %UserToneVisualizer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var _user_start_position: Vector2
var _random_start_position: Vector2

func _ready():
	var save_visualizer_service: SaveVisualizerService = ServiceProvider.get_service("SaveVisualizerService")
	save_visualizer_service.load_random_visualizer(random_tone_visualizer)
	save_visualizer_service.load_user_visualizer(user_tone_visualizer)
	_random_start_position = random_tone_visualizer.position
	_user_start_position = user_tone_visualizer.position
	animation_player.play("flip_user_visualizer")
	# apparently merge_visualizers is just cursed so we're not gonna use it anymore!!!
	#animation_player.queue("merge_visualizers")
	animation_player.queue("merge_visualizers_2")
	animation_player.queue("show_win_screen")

func _process(_delta: float) -> void:
	# Gets the midpoint between the two positions
	var center = (_user_start_position + _random_start_position) / 2.0
	user_tone_visualizer.position = _user_start_position.lerp(center, merge_amount)
	random_tone_visualizer.position = _random_start_position.lerp(center, merge_amount)

func _on_try_again_button_pressed():
	# We actually want to load a new instance of the main scene
	# and avoid any statefulness from the old instance,
	# even though we're still tracking the old instance

	# We want to get the difficulty from the old instance
	# to pass to the new instance
	var difficulty = main.difficulty
	# Remove old main scene
	main.queue_free()
	var new_main = main_scene.instantiate()
	new_main.difficulty = difficulty
	var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")
	scene_transition_service.zoom_in(self, new_main)

func _on_select_difficulty_pressed():
	# We still want to remove the old main scene here
	main.queue_free()
	var difficulty_scene_instance = difficulty_scene.instantiate()
	var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")
	scene_transition_service.zoom_out(self, difficulty_scene_instance)
