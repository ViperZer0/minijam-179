extends Node

## The frequency of the base note
## cycles per second
@export var base_frequency: float = 440.0

@export var harmonics: Array[Harmonic]

@onready var audio_player: AudioStreamPlayer = %AudioPlayer
## The sample rate is samples per second
@onready var sample_rate: int = audio_player.stream.mix_rate

var _t: float = 0.0
# We need to track the highest possible amplitude to normalize all amplitudes
var _max_amplitude: float = 0.0

# The currently playing sound
var playback: AudioStreamGeneratorPlayback

func _ready():
	audio_player.play()
	playback = audio_player.get_stream_playback()
	_max_amplitude = _calc_max()
	fill_buffer()

func _process(_delta: float):
	fill_buffer()

func fill_buffer():
	# How much to increase _t by
	var increment: float = 1.0 / sample_rate
	var frames_available = playback.get_frames_available()
	for i in range(frames_available):
		# Audio is in stereo, x is left and y is right
		playback.push_frame(Vector2.ONE * _get_amplitude_at(_t))
		_t += increment

func _calc_max() -> float:
	var max_amplitude: float = 0.0
	for harmonic in harmonics:
		max_amplitude += harmonic.harmonic_strength
	return max_amplitude

## Returns an amplitude between 0 and 1 based on the harmonics and stuff.
func _get_amplitude_at(t: float) -> float:
	var cur_total: float = 0.0
	for harmonic in harmonics:
		cur_total += harmonic.harmonic_strength * sin((harmonic.harmonic_number + 1) * base_frequency * TAU * t)

	return cur_total / _max_amplitude


