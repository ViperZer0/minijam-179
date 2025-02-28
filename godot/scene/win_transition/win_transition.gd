extends Control

@onready var random_tone_visualizer: AudioVisualizer = %RandomToneVisualizer
@onready var user_tone_visualizer: AudioVisualizer = %UserToneVisualizer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var merge_amount: float = 0.0
var _user_start_position: Vector2
var _random_start_position: Vector2

func _ready():
	var save_visualizer_service: SaveVisualizerService = ServiceProvider.get_service("SaveVisualizerService")
	save_visualizer_service.load_random_visualizer(random_tone_visualizer)
	save_visualizer_service.load_user_visualizer(user_tone_visualizer)
	_random_start_position = random_tone_visualizer.position
	_user_start_position = user_tone_visualizer.position
	animation_player.play("flip_user_visualizer")
	animation_player.queue("merge_visualizers")

func _process(_delta: float) -> void:
	# Gets the midpoint between the two positions
	var center = (_user_start_position + _random_start_position) / 2.0
	user_tone_visualizer.position = _user_start_position.lerp(center, merge_amount)
	random_tone_visualizer.position = _random_start_position.lerp(center, merge_amount)

func _on_animation_player_animation_finished(anim_name:StringName):
	pass
	# If we finish the first animation, switch to the second one
	#if anim_name == "flip_user_visualizer":
		#animation_player.play("merge_visualizers")
