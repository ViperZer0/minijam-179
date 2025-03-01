extends Button
class_name SoundButton

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_pressed():
	audio_player.play()
