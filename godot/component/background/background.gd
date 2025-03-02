extends ColorRect

@export var emitter_enabled: bool:
	get:
		if particle_emitter:
			return particle_emitter.emitting
		return false
	set(value):
		if particle_emitter:
			particle_emitter.emitting = value
@export var emitter_speed: float = 800.0

@onready var particle_emitter: CPUParticles2D = %ParticleEmitter
@onready var timer: Timer = $ParticleBurstCooldown

func _process(_delta: float) -> void:
	var velocity = get_local_mouse_position() - particle_emitter.position
	velocity = velocity.normalized() * emitter_speed * _delta
	particle_emitter.position += velocity

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("trigger_particle_burst"):
		print("Boo!")
		particle_emitter.initial_velocity_max = 1000
		timer.start()

func _on_particle_burst_cooldown_timeout():
	particle_emitter.initial_velocity_max = 100
