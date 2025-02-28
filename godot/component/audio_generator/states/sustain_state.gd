extends AdsrState
class_name SustainState

## Sustain level
var sustain_level: float = 1.0

@export var attack_state: State
@export var release_state: State

@onready var audio_generator: AudioSignalGenerator = owner
@onready var state_machine: AdsrStateMachine = owner.get_node("ADSRStateMachine")

func enter():
	super.enter()
	print("Sustain!")
	sustain_level = audio_generator.sustain
	audio_generator.current_amplitude = sustain_level

func exit():
	print("Exiting")

func note_on():
	state_machine.switch_state(attack_state)

func note_off():
	state_machine.switch_state(release_state)
