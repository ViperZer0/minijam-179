extends PanelContainer
@export var num_harmonics: int = 16

@onready var random_tone: AudioSignalGenerator = %RandomTone
var random_harmonics: Harmonics
@onready var user_tone: AudioSignalGenerator = %UserTone
@onready var audio_slider_grid: AudioSliderGrid = %AudioSliderGrid

func _ready() -> void:
	audio_slider_grid.num_harmonics = num_harmonics
	random_harmonics = Harmonics.generate_random_harmonics(num_harmonics, 0.35)
	random_harmonics.normalize()
	random_tone.start_processing(random_harmonics)
	user_tone.start_processing(audio_slider_grid.get_harmonics())

func _process(_delta) -> void:
	if audio_slider_grid.has_changed():
		user_tone.harmonics = audio_slider_grid.get_harmonics()

func _on_check_difference_button_pressed() -> void:
	print(random_harmonics.error(audio_slider_grid.get_harmonics().normalize()))

func _on_play_user_tone_button_pressed() -> void:
	user_tone.toggle_note()

func _on_play_random_tone_button_pressed() -> void:
	random_tone.toggle_note()
