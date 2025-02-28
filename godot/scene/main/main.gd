extends PanelContainer

@onready var random_tone: AudioSignalGenerator = %RandomTone
@onready var user_tone: AudioSignalGenerator = %UserTone
@onready var audio_slider_grid: AudioSliderGrid = %AudioSliderGrid

func _process(_delta) -> void:
	user_tone.harmonics = audio_slider_grid.get_harmonics()

func _on_check_difference_button_pressed() -> void:
	pass # Replace with function body.

func _on_play_user_tone_button_pressed() -> void:
	pass # Replace with function body.

func _on_play_random_tone_button_pressed() -> void:
	pass # Replace with function body.

