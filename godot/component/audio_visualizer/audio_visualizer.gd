@tool
extends Control
class_name AudioVisualizer

@export var resolution: int = 128

@export var harmonics: Harmonics:
	get:
		return _harmonics
	set(value):
		_harmonics = value
		if line != null:
			calc_line()

var _harmonics: Harmonics

@export_range(-1, 1, 0.1) var y_scaling: float:
	get:
		return _y_scaling
	set(value):
		_y_scaling = value
		if line != null:
			calc_line()

var _y_scaling: float = 1.0

@onready var line: Line2D = $Line2D

func _ready() -> void:
	get_viewport().size_changed.connect(_on_viewport_size_changed)

#func _process(_delta) -> void:
	#calc_line()

func _calc_max() -> float:
	var max_amplitude: float = 0.0
	for harmonic in _harmonics.harmonics:
		max_amplitude += harmonic.harmonic_strength
	return max_amplitude

func calc_line() -> void:
	line.clear_points()
	var max_amplitude = _calc_max()
	var horiz_scale = size.x
	var vert_scale = size.y
	for i in range(0, resolution):
		var cur_total: float = 0.0
		for harmonic in _harmonics.harmonics:
			cur_total += harmonic.harmonic_strength * sin((harmonic.harmonic_number + 1) * TAU * i / resolution)

		# Normalize current y index to be between -1 and 1.
		var normalized_total = cur_total / max_amplitude * _y_scaling
		# Normalize current y index to be between 0 and 1
		var normalized_y = normalized_total / 2 + 0.5
		# Now we scale it
		var y = normalized_y * vert_scale

		# Now we do the x coordinate A
		# x is some value between 0 and 1 where 1 is the last point and 0 is the first point.
		# Then we multiply that by the horizontal scale
		var x = float(i) / float(resolution) * horiz_scale
		line.add_point(Vector2(x, y))

# Recalculate the line points when the viewport size changes
func _on_viewport_size_changed() -> void:
	calc_line()
