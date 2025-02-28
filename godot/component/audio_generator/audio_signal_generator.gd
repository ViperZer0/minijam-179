extends Node
class_name AudioSignalGenerator

## The frequency of the base note
## cycles per second
@export_group("Base Audio Properties")
@export var base_frequency: float = 440.0

@export var harmonics: Harmonics:
	get:
		return _harmonics
	set(value):
		_harmonics = value
		if value != null:
			# recalculate max amplitude
			_max_amplitude = _calc_max()

@export_group("ADSR Envelope")
var _harmonics: Harmonics

## Time in seconds to reach max volume on gate on
@export var attack: float = 0.0

## Time in seconds to drop from max volume to sustain volume
@export var decay: float = 0.0

## From 0-1 how loud sustain volume is
@export_range(0, 1, 0.05) var sustain: float = 0.0

## Time in seconds to drop from sustain to nothing on gate off
@export var release: float = 0.0

@onready var audio_player: AudioStreamPlayer = %AudioPlayer
## The sample rate is samples per second
@onready var sample_rate: int = audio_player.stream.mix_rate
@onready var state_machine: AdsrStateMachine = %ADSRStateMachine
## Current modified amplitude, from 0 to 1
var current_amplitude: float = 0.0

# True if the note is on, false otherwise.
# Mostly just used for toggling notes
var _gate: bool = false
var _t: float = 0.0
# We need to track the highest possible amplitude to normalize all amplitudes
var _max_amplitude: float = 0.0
# how long it takes to do a full period, for looping _t
@onready var _period: float = 1.0 / base_frequency

# The currently playing sound
var playback: AudioStreamGeneratorPlayback

func _process(_delta: float):
	if playback != null:
		audio_player.volume_db = linear_to_db(current_amplitude)
		_fill_buffer()

#func _unhandled_input(event):
	#if event.is_action_pressed("play"):
		#print("Start")
		#start_note()

	#if event.is_action_released("play"):
		#print("A")
		#stop_note()

func start_processing(harmonics: Harmonics):
	if harmonics == null:
		# Generate no harmonics at all
		_harmonics = Harmonics.new()
	else:
		_harmonics = harmonics

	audio_player.play()
	playback = audio_player.get_stream_playback()
	_max_amplitude = _calc_max()
	print(_max_amplitude)
	_fill_buffer()

func start_note():
	_gate = true
	state_machine.current_state.note_on()

func stop_note():
	_gate = false
	state_machine.current_state.note_off()

func toggle_note():
	if _gate:
		stop_note()
	else:
		start_note()

func _fill_buffer():
	# How much to increase _t by
	var increment: float = 1.0 / sample_rate
	var frames_available = playback.get_frames_available()
	for i in range(frames_available):
		# Audio is in stereo, x is left and y is right
		playback.push_frame(Vector2.ONE * _get_amplitude_at(_t))
		_t = fmod(_t + increment, _period)

func _calc_max() -> float:
	var max_amplitude: float = 0.0
	for harmonic in _harmonics.harmonics:
		max_amplitude += harmonic.harmonic_strength
	return max_amplitude

## Returns an amplitude between -1 and 1 based on the harmonics and stuff.
func _get_amplitude_at(t: float) -> float:
	var cur_total: float = 0.0
	for harmonic in _harmonics.harmonics:
		cur_total += harmonic.harmonic_strength * sin((harmonic.harmonic_number + 1) * base_frequency * TAU * t)

	if _max_amplitude == 0.0:
		return 0.0

	return cur_total / _max_amplitude
