extends AdsrState
class_name OffState

@export var attack_state: State

@onready var audio_generator: AudioSignalGenerator = owner
@onready var state_machine: AdsrStateMachine = owner.get_node("ADSRStateMachine")
@onready var audio_player: AudioStreamPlayer = audio_generator.get_node("AudioPlayer")

func enter():
	super.enter()
	print("Off!")
	# audio_player.stop()
	audio_generator.current_amplitude = 0.0

func note_on():
	state_machine.switch_state(attack_state)
