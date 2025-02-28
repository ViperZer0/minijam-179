extends AdsrState
class_name AttackState

## Time to reach max volume
var attack_time: float = 0.0

@export var decay_state: State

@export var release_state: State

@onready var audio_generator: AudioSignalGenerator = owner
@onready var state_machine: AdsrStateMachine = owner.get_node("ADSRStateMachine")
@onready var audio_player: AudioStreamPlayer = audio_generator.get_node("AudioPlayer")

var current_amplitude: float = 0.0

func enter():
	# We call this here instead of in ready in case we want to change the attack time during runtime
	super.enter()
	attack_time = owner.attack
	print("Attack!")
	# audio_player.play()

func _process(delta: float):
	if _is_active:
		current_amplitude = min(1.0, current_amplitude + delta / attack_time)
		audio_generator.current_amplitude = current_amplitude

		if current_amplitude >= 1.0:
			state_machine.switch_state(decay_state)

func exit():
	super.exit()
	# Reset tracked amplitude
	current_amplitude = 0.0

func note_on():
	state_machine.switch_state(self)

func note_off():
	# Skip and go straight to release state
	state_machine.switch_state(release_state)
