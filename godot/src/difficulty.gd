## Represents a class of difficulty and defines the parameters of that difficulty
extends Resource
class_name Difficulty

## The minimum number of harmonics this difficulty should have
@export_range(0, 16, 1, "or_greater") var min_num_harmonics: int = 0
## The maximum (inclusive) number of harmonics this difficulty should have
@export_range(0, 16, 1, "or_greater") var max_num_harmonics: int = 0
## How precise the user's answer needs to be for the game to consider it a success.
## Uses squared error values, generally a pretty good guess is probably 0.05 or less.
@export var error_margin: float = 0.05

func _init(min_num_harmonics := 0, max_num_harmonics := 0, error_margin := 0.05):
	self.min_num_harmonics = min_num_harmonics
	self.max_num_harmonics = max_num_harmonics
	self.error_margin = error_margin

func pick_num_harmonics() -> int:
	return randi_range(min_num_harmonics, max_num_harmonics)

