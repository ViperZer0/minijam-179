## Keeps track of when an animation event should trigger.
## Probably used exclusively in the Tutorial scene
extends Resource
class_name TriggerEvent

## Which number dialogue to trigger the animation event on
@export var dialogue_trigger: int

@export var animation_name: String

func _init(trigger_num := 0, anim_name := ""):
	dialogue_trigger = trigger_num
	animation_name = anim_name
