extends Control
class_name FadeLabel

signal fade_in_complete(fade_label: FadeLabel)
signal fade_out_complete(fade_label: FadeLabel)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_in():
	animation_player.play("fade_in")

func fade_out():
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "fade_in":
		fade_in_complete.emit(self)
	elif anim_name == "fade_out":
		fade_out_complete.emit(self)
