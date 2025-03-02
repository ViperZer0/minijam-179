extends Node
class_name SceneTransitionService

@export var from_scene: Control
@export var from_scene_scale: float:
	get:
		return _from_scene_scale
	set(value):
		_from_scene_scale = value
		if from_scene != null:
			_scale_scene(from_scene, value)

var _from_scene_scale: float = 1.0

@export var from_scene_opacity: float:
	get:
		return _from_scene_opacity
	set(value):
		_from_scene_opacity = value
		if from_scene != null:
			_set_scene_opacity(from_scene, value)

var _from_scene_opacity: float = 1.0

@export var to_scene: Control
@export var to_scene_scale: float:
	get:
		return _to_scene_scale
	set(value):
		_to_scene_scale = value
		if to_scene != null:
			_scale_scene(to_scene, value)

var _to_scene_scale: float = 1.0

@export var to_scene_opacity: float:
	get:
		return _to_scene_opacity
	set(value):
		_to_scene_opacity = value
		if to_scene != null:
			_set_scene_opacity(to_scene, value)

var _to_scene_opacity: float = 1.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Loads the next scene and zooms into it from this scene
func zoom_in(from: Control, to: Control) -> void:
	from_scene = from
	to_scene = to
	get_tree().root.add_child(to)
	animation_player.play("zoom_in")

## Loads the next scene and zooms outwards to it. Basically the reverse of the above.
func zoom_out(from: Control, to: Control) -> void:
	from_scene = from
	to_scene = to
	get_tree().root.add_child(to)
	animation_player.play("zoom_out")

func _scale_scene(scene: Control, factor: float) -> void:
	scene.pivot_offset = scene.size / 2
	scene.scale = Vector2(factor, factor)

func _set_scene_opacity(scene: Control, opacity: float) -> void:
	scene.modulate.a = opacity

func _on_animation_player_animation_finished(_anim_name: StringName):
	# Unloading old scene
	from_scene.queue_free()
	from_scene = null
