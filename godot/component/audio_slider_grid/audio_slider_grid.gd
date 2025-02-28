extends HBoxContainer
class_name AudioSliderGrid

@export var num_harmonics: int = 16

@export_file("*.tscn") var audio_slider_path = ""
@onready var _audio_slider_scene: PackedScene = load(audio_slider_path)

func _ready():
	for i in range(0, num_harmonics):
		var slider = _audio_slider_scene.instantiate()
		slider.add_to_group("sliders")
		add_child(slider)

func get_harmonics() -> Array[Harmonic]:
	var harmonics: Array[Harmonic]
	var harmonic_index: int = 0
	for child: Node in get_children():
		if child.is_in_group("sliders"):
			# We know this child is a VSlider
			var slider: VSlider = child
			print(slider.name)
			# Idk why but we can't inline this
			var h = Harmonic.new()
			h.harmonic_number = harmonic_index
			h.harmonic_strength = slider.value
			harmonics.append(h)
			harmonic_index += 1

	return harmonics
