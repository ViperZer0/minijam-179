extends MarginContainer
class_name Settings

@onready var music_bus_idx: int = AudioServer.get_bus_index("Music")
@onready var music_slider: HSlider = %MusicSlider
@onready var tone_bus_idx: int = AudioServer.get_bus_index("GameTones")
@onready var tone_slider: HSlider = %ToneSlider
@onready var sfx_bus_idx: int = AudioServer.get_bus_index("SFX")
@onready var sfx_slider: HSlider = %SFXSlider

func _ready():
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_idx))
	tone_slider.value = db_to_linear(AudioServer.get_bus_volume_db(tone_bus_idx))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))

func _on_buffer_size_entry_value_changed(value:float):
	pass # Replace with function body.

func _on_sample_rate_entry_value_changed(value:float):
	pass # Replace with function body.

func _on_sfx_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))

func _on_tone_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(tone_bus_idx, linear_to_db(value))

func _on_music_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))

