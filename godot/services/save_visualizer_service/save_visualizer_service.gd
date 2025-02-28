## This class saves the visualizer position between the transition from the main scene to the win animation.
extends Node
class_name SaveVisualizerService

var random_tone_visualizer_position: Vector2
var random_tone_visualizer_size: Vector2
var random_tone_visualizer_harmonics: Harmonics
var user_tone_visualizer_position: Vector2
var user_tone_visualizer_size: Vector2
var user_tone_visualizer_harmonics: Harmonics

func save_random_visualizer(random_visualizer: AudioVisualizer):
	random_tone_visualizer_position = random_visualizer.global_position
	random_tone_visualizer_size = random_visualizer.size
	random_tone_visualizer_harmonics = random_visualizer.harmonics

func load_random_visualizer(random_visualizer: AudioVisualizer):
	random_visualizer.global_position = random_tone_visualizer_position
	random_visualizer.size = random_tone_visualizer_size
	random_visualizer.harmonics = random_tone_visualizer_harmonics

func save_user_visualizer(user_visualizer: AudioVisualizer):
	user_tone_visualizer_position = user_visualizer.global_position
	user_tone_visualizer_size = user_visualizer.size
	user_tone_visualizer_harmonics = user_visualizer.harmonics

func load_user_visualizer(user_visualizer: AudioVisualizer):
	user_visualizer.global_position = user_tone_visualizer_position
	user_visualizer.size = user_tone_visualizer_size
	user_visualizer.harmonics = user_tone_visualizer_harmonics

