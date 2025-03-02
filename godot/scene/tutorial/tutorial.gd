extends Control

@export var animation_triggers: Array[TriggerEvent]
@export var harmonics: Harmonics
@export_file("*.tscn") var back_scene_path: String = ""

var current_dialogue: int = 0
var dialogue_labels: Array[FadeLabel]

@onready var audio_visualizer: AudioVisualizer = %AudioVisualizer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_signal: AudioSignalGenerator = $AudioSignalGenerator
@onready var audio_slider_grid: AudioSliderGrid = $AudioSliderGrid
@onready var back_scene: Control = load(back_scene_path).instantiate()

@export var add_second_harmonic: float:
	get:
		# This feels so gross lol
		return harmonics.harmonics[1].harmonic_strength
	set(value):
		harmonics.harmonics[1].harmonic_strength = value
		# We need this to refresh the max amplitude so it doesn't clip
		audio_signal.harmonics = harmonics

@export var add_third_harmonic: float:
	get:
		return harmonics.harmonics[2].harmonic_strength
	set(value):
		harmonics.harmonics[2].harmonic_strength = value
		audio_signal.harmonics = harmonics

func _ready():
	var dialogue_group: Node = %Dialogue
	# This will cast nodes to be the correct type
	dialogue_labels.assign(dialogue_group.find_children("*", "FadeLabel", false, true))
	# Show the first dialogue box!
	if dialogue_labels.size() > 0:
		dialogue_labels[0].fade_in()
	else:
		push_warning("No dialogue labels found!")

	audio_visualizer.harmonics = harmonics
	audio_signal.start_processing(harmonics)


func _process(_delta: float):
	audio_visualizer.calc_line()
	if audio_slider_grid.has_changed():
		harmonics = audio_slider_grid.get_harmonics()
		audio_signal.harmonics = harmonics
		audio_visualizer.harmonics = harmonics


# Mouse clicks are not handled by _unhandled_input,
# and keypresses are not handled by _gui_input lol
func _gui_input(event: InputEvent):
	if event.is_action_pressed("progress_dialogue"):
		move_to_next_dialogue()
		audio_player.play()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("progress_dialogue"):
		move_to_next_dialogue()
		audio_player.play()

# Increments the current dialogue, hides the old dialogue, shows the new one.
func move_to_next_dialogue():
	if current_dialogue < dialogue_labels.size():
		dialogue_labels[current_dialogue].fade_out()
		current_dialogue += 1
		if current_dialogue < dialogue_labels.size():
			dialogue_labels[current_dialogue].fade_in()

	for trigger_event in animation_triggers:
		if trigger_event.dialogue_trigger == current_dialogue:
			animation_player.play(trigger_event.animation_name)

# Sets the grid harmonics to what they are right now so there's no discrepancy
# visually vs auditorially
func set_grid_harmonics():
	audio_slider_grid.set_harmonics(harmonics)

func _on_back_button_pressed():
	var scene_transition_service: SceneTransitionService = ServiceProvider.get_service("SceneTransitionService")
	audio_signal.stop_note()
	scene_transition_service.zoom_out(self, back_scene)


