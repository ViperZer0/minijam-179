extends HSlider

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_drag_started():
	audio_player.play()

