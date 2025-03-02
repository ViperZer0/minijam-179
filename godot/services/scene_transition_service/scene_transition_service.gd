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

var _unload_last_scene: bool = true
var _last_scene_transition_type: String = ""

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Loads the next scene and zooms into it from this scene
func zoom_in(from: Control, to: Control, unload_from_scene := true) -> void:
	from_scene = from
	to_scene = to
	get_tree().root.add_child(to)
	animation_player.play("zoom_in")
	_last_scene_transition_type = "zoom_in"
	_unload_last_scene = unload_from_scene

## Loads the next scene and zooms outwards to it. Basically the reverse of the above.
func zoom_out(from: Control, to: Control, unload_from_scene := true) -> void:
	from_scene = from
	to_scene = to
	get_tree().root.add_child(to)
	animation_player.play("zoom_out")
	_last_scene_transition_type = "zoom_out"
	_unload_last_scene = unload_from_scene

## Undoes the last zoom. If we zoomed in from from to to, this function zooms out from to to from.
## This only works if zoom_in or zoom_out was called with unload_from_scene = false, otherwise
## from doesn't exist.
## Like zoom_in and zoom_out, unload_from_scene = true will delete the new from scene (which is the old to scene)
func reverse_last_zoom(unload_from_scene := true) -> void:
	if !is_instance_valid(from_scene):
		push_error("Attempted to call reverse_last_zoom when from_scene was unloaded. Did you forget to call zoom_in or zoom_out with unload_from_scene = false?")
		return

	if _last_scene_transition_type == "zoom_in":
		zoom_out(to_scene, from_scene, unload_from_scene)
	elif _last_scene_transition_type == "zoom_out":
		zoom_in(to_scene, from_scene, unload_from_scene)

func _scale_scene(scene: Control, factor: float) -> void:
	scene.pivot_offset = scene.size / 2
	scene.scale = Vector2(factor, factor)

func _set_scene_opacity(scene: Control, opacity: float) -> void:
	scene.modulate.a = opacity

func _on_animation_player_animation_finished(_anim_name: StringName):
	# unload last scene unless unloading was disabled and we'll be going back to it.
	if _unload_last_scene:
		# Unloading old scene
		from_scene.queue_free()
		from_scene = null

	# We do still want to remove it from the tree I think???
	# Note that this won't call _ready() and stuff a second time.
	else:
		get_tree().root.remove_child(from_scene)

