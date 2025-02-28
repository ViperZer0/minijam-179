extends Node
class_name AdsrStateMachine

@export var starting_state: AdsrState
var current_state: AdsrState

func _ready():
	current_state = starting_state
	current_state.enter()

func switch_state(new_state: AdsrState):
	print("Switching from ", current_state.name, " to ", new_state.name)
	current_state.exit()
	new_state.enter()
	current_state = new_state
