extends MarginContainer
class_name Main
## Number of harmonics to use
@export var num_harmonics: int = 16
## Threshold before a given answer is approved as a success
@export var error_threshold: float = 0.05
## How many harmonics the target tone should have.
@export var num_target_harmonics: int = 2

@export_file("*.tscn") var win_transition_path: String = ""
@onready var _win_transition_scene: PackedScene = load(win_transition_path)

@export_file("*.tscn") var difficulty_scene_path: String = ""
@onready var difficulty_scene: PackedScene = load(difficulty_scene_path)

@export_file("*.tscn") var settings_scene_path: String = ""
@onready var settings_scene: PackedScene = load(settings_scene_path)

# Track the difficulty, for raisins
@export var difficulty: Difficulty:
	get:
		return _difficulty
	set(value):
		_difficulty = value
		num_target_harmonics = value.pick_num_harmonics()
		error_threshold = value.error_margin

var _difficulty: Difficulty

@onready var random_tone: AudioSignalGenerator = %RandomTone
@onready var random_tone_visualizer: AudioVisualizer = %RandomToneVisualizer
var random_harmonics: Harmonics
@onready var user_tone: AudioSignalGenerator = %UserTone
@onready var user_tone_visualizer: AudioVisualizer = %UserToneVisualizer
@onready var audio_slider_grid: AudioSliderGrid = %AudioSliderGrid
@onready var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")

func _ready() -> void:
	# Don't tell anyone, this doesn't actually do anything,
	# But i think I'm okay leaving it like this. Visually I think 16 sliders looks better,
	# Even though we only use 8 (which i think is for the best)
	audio_slider_grid.num_harmonics = num_harmonics
	random_harmonics = Harmonics.generate_random_harmonics(num_harmonics, num_target_harmonics).normalize()
	random_tone.start_processing(random_harmonics)
	random_tone_visualizer.harmonics = random_harmonics
	# We should call this deferred so it updates to the size of the container
	random_tone_visualizer.calc_line.call_deferred()
	user_tone.start_processing(audio_slider_grid.get_harmonics())

func _process(_delta) -> void:
	if audio_slider_grid.has_changed():
		var user_harmonics = audio_slider_grid.get_harmonics()
		user_tone.harmonics = user_harmonics
		user_tone_visualizer.harmonics = user_harmonics

func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("force_win"):
		move_to_win_scene()

func move_to_win_scene() -> void:
	# Set up and save positions of the visualizers for animations first
	var save_visualizer_service: SaveVisualizerService = ServiceProvider.get_service("SaveVisualizerService")
	save_visualizer_service.save_user_visualizer(user_tone_visualizer)
	save_visualizer_service.save_random_visualizer(random_tone_visualizer)
	var scene: WinTransition  = _win_transition_scene.instantiate()
	scene.main = self
	# Instead of changing the scene we're gonna add it on top of this
	get_tree().root.add_child(scene)
	# We'll also hide our own visualizers.
	# We don't want to use hide since that will move stuff around, they should still
	# Take up space
	random_tone_visualizer.modulate.a = 0
	user_tone_visualizer.modulate.a = 0
	# Stop any existing notes
	random_tone.stop_note()
	user_tone.stop_note()
	# Set adsr??? Super hacky????
	# Halve the volume of both tones so they don't clip
	# Maybe we should be doing that anyways???
	random_tone.amplitude_scaling = 0.5
	random_tone.attack = 0.0
	random_tone.decay = 4.0
	random_tone.sustain = 0.0
	random_tone.release = 0.0
	user_tone.amplitude_scaling = 0.5
	user_tone.attack = 0.0
	user_tone.decay = 4.0
	user_tone.sustain = 0.0
	user_tone.release = 0.0
	random_tone.start_note()
	user_tone.start_note()

func _on_check_difference_button_pressed() -> void:
	if audio_slider_grid.get_harmonics().normalize() == null:
		# Treat this as an error
		return
	var error = random_harmonics.error(audio_slider_grid.get_harmonics().normalize())
	print(error)
	if error < error_threshold:
		move_to_win_scene()

func _on_play_user_tone_button_pressed() -> void:
	user_tone.toggle_note()

func _on_play_random_tone_button_pressed() -> void:
	random_tone.toggle_note()

func _on_back_button_pressed():
	var difficulty_scene_instance = difficulty_scene.instantiate()
	scene_transition_service.zoom_out(self, difficulty_scene_instance)

func _on_settings_button_pressed():
	var settings_scene_instance = settings_scene.instantiate()
	scene_transition_service.zoom_out(self, settings_scene_instance, false)
