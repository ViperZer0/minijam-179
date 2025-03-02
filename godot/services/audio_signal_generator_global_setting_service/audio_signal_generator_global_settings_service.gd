extends Node
class_name AudioSignalGeneratorGlobalSettingsService

signal sample_rate_changed(sample_rate: int)
signal buffer_size_changed(buffer_size: float)

## Sample rate to generate, in Hz.
## Higher is better but requires more computation.
@export var sample_rate: int:
	get:
		return _sample_rate
	set(value):
		_sample_rate = value
		sample_rate_changed.emit(value)

var _sample_rate: int = 22050

## Size of the buffer in seconds.
## Smaller is faster but requires more computation
@export var buffer_size: float:
	get:
		return _buffer_size
	set(value):
		_buffer_size = value
		buffer_size_changed.emit(value)

var _buffer_size: float = 0.1
