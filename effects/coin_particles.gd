extends Node2D

@export var sound_effect: AudioStream
@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
    start()

func start() -> void:
    particles.emitting = true
    SoundManager.play_sound(sound_effect)

func _on_gpu_particles_2d_finished() -> void:
    queue_free()
