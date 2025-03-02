extends MarginContainer
class_name Settings

@onready var global_settings: AudioSignalGeneratorGlobalSettingsService = ServiceProvider.get_service("AudioSignalGeneratorGlobalSettingsService")
@onready var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")

@onready var music_bus_idx: int = AudioServer.get_bus_index("Music")
@onready var music_slider: HSlider = %MusicSlider
@onready var tone_bus_idx: int = AudioServer.get_bus_index("GameTones")
@onready var tone_slider: HSlider = %ToneSlider
@onready var sfx_bus_idx: int = AudioServer.get_bus_index("SFX")
@onready var sfx_slider: HSlider = %SFXSlider
@onready var sample_rate_entry: SpinBox = %SampleRateEntry
@onready var buffer_size_entry: SpinBox = %BufferSizeEntry

func _ready():
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_idx))
	tone_slider.value = db_to_linear(AudioServer.get_bus_volume_db(tone_bus_idx))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))
	sample_rate_entry.value = global_settings.sample_rate
	buffer_size_entry.value = global_settings.buffer_size

func _on_buffer_size_entry_value_changed(value:float):
	global_settings.buffer_size = value

func _on_sample_rate_entry_value_changed(value:float):
	global_settings.sample_rate = int(value)

func _on_sfx_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))

func _on_tone_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(tone_bus_idx, linear_to_db(value))

func _on_music_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))

func _on_back_button_pressed():
	# go back to wherever we cane from
	scene_transition_service.reverse_last_zoom()
