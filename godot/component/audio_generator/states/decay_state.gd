extends AdsrState
class_name DecayState

## Decay time
var decay_time: float = 0.0

## Target sustain level
var sustain_level: float = 1.0

@export var attack_state: State
@export var sustain_state: State
@export var release_state: State

@onready var audio_generator: AudioSignalGenerator = owner
@onready var state_machine: AdsrStateMachine = owner.get_node("ADSRStateMachine")

var current_amplitude: float = 1.0

func enter():
	super.enter()
	print("Decay!")
	decay_time = audio_generator.decay
	sustain_level = audio_generator.sustain

func _process(delta: float):
	if _is_active:
		current_amplitude = max(sustain_level, current_amplitude - (1.0 - sustain_level) / decay_time * delta)
		print(current_amplitude)
		audio_generator.current_amplitude = current_amplitude

		if current_amplitude <= sustain_level:
			state_machine.switch_state(sustain_state)

func exit():
	super.exit()
	# Reset current amplitude
	current_amplitude = 1.0

func note_on():
	state_machine.switch_state(attack_state)

func note_off():
	state_machine.switch_state(release_state)


