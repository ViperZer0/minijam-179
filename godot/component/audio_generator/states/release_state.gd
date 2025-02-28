extends AdsrState
class_name ReleaseState

## Release time
var release_time: float = 0.0

@export var attack_state: State
@export var off_state: State

@onready var audio_generator: AudioSignalGenerator = owner
@onready var state_machine: AdsrStateMachine = owner.get_node("ADSRStateMachine")

var current_amplitude: float = 1.0

var _starting_amplitude: float = 1.0

func enter() -> void:
	super.enter()
	print("Release!")
	release_time = audio_generator.release
	current_amplitude = audio_generator.current_amplitude
	_starting_amplitude = current_amplitude

func _process(delta: float) -> void:
	if _is_active:
		# Do we want to always take the same amount of time to release?
		# Or do we want to fade faster if the note was never fully activated?
		current_amplitude = max(0.0, current_amplitude - (_starting_amplitude / release_time * delta))
		audio_generator.current_amplitude = current_amplitude

		if current_amplitude <= 0.0:
			state_machine.switch_state(off_state)

func note_on() -> void:
	state_machine.switch_state(attack_state)

