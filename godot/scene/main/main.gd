extends PanelContainer
@export var num_harmonics: int = 16
@export var error_threshold: float = 0.05

@export_file("*.tscn") var win_transition_path: String = ""
@onready var _win_transition_scene: PackedScene = load(win_transition_path)

@onready var random_tone: AudioSignalGenerator = %RandomTone
@onready var random_tone_visualizer: AudioVisualizer = %RandomToneVisualizer
var random_harmonics: Harmonics
@onready var user_tone: AudioSignalGenerator = %UserTone
@onready var user_tone_visualizer: AudioVisualizer = %UserToneVisualizer
@onready var audio_slider_grid: AudioSliderGrid = %AudioSliderGrid

func _ready() -> void:
	audio_slider_grid.num_harmonics = num_harmonics
	random_harmonics = Harmonics.generate_random_harmonics(num_harmonics, 0.35).normalize()
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

func move_to_win_scene() -> void:
	# Set up and save positions of the visualizers for animations first
	var save_visualizer_service: SaveVisualizerService = ServiceProvider.get_service("SaveVisualizerService")
	save_visualizer_service.save_user_visualizer(user_tone_visualizer)
	save_visualizer_service.save_random_visualizer(random_tone_visualizer)
	# Now we can transition
	get_tree().change_scene_to_packed(_win_transition_scene)

func _on_check_difference_button_pressed() -> void:
	var error = random_harmonics.error(audio_slider_grid.get_harmonics().normalize())
	print(error)
	#if error < error_threshold:
	move_to_win_scene()

func _on_play_user_tone_button_pressed() -> void:
	user_tone.toggle_note()

func _on_play_random_tone_button_pressed() -> void:
	random_tone.toggle_note()
