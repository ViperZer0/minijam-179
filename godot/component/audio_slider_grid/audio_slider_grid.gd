extends HBoxContainer
class_name AudioSliderGrid

@export var num_harmonics: int = 16

@export_file("*.tscn") var audio_slider_path = ""
@onready var _audio_slider_scene: PackedScene = load(audio_slider_path)
var _value_changed: bool = false

func _ready():
	for i in range(0, num_harmonics):
		var slider: VSlider = _audio_slider_scene.instantiate()
		slider.add_to_group("sliders")
		slider.value_changed.connect(_on_slider_value_changed)
		add_child(slider)

func has_changed() -> bool:
	return _value_changed

# Set the sliders to where they would be with this set of harmonics
func set_harmonics(harmonics: Harmonics) -> void:
	# In theory we could generate more sliders if the amount of harmonics is different but man let's just say they're the same okay?
	assert(num_harmonics == get_children().size())
	# How about this, we'll also accept LESS harmonics than we need.
	# Yah
	assert(num_harmonics > harmonics.harmonics.size())
	var harmonic_index: int = 0
	for child: Node in get_children():
		if child.is_in_group("sliders"):
			var slider: VSlider = child
			var harmonic = harmonics.find_harmonic_index(harmonic_index)
			if harmonic != null:
				slider.value = harmonics.find_harmonic_index(harmonic_index).harmonic_strength
			harmonic_index += 1

func get_harmonics() -> Harmonics:
	var harmonics: Array[Harmonic]
	var harmonic_index: int = 0
	for child: Node in get_children():
		if child.is_in_group("sliders"):
			# We know this child is a VSlider
			var slider: VSlider = child
			# Idk why but we can't inline this
			# I know why we couldn't inline it btw,
			# we totally can now
			var h = Harmonic.new(harmonic_index, slider.value)
			harmonics.append(h)
			harmonic_index += 1

	var h = Harmonics.new(harmonics)
	# Reset value changed stat
	_value_changed = false
	return h

func _on_slider_value_changed(_value: float) -> void:
	_value_changed = true
