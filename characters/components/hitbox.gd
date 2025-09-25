class_name Hitbox
extends Area2D

@export var contact_sound: AudioStream
@export var monitoring_default := false
@export var damage: int = 10
@export var knockback_velocity: float = 100.0
@export var can_deflect = false
@export var can_be_deflected = true
@export var stun = false

signal hit

func _ready():
    monitoring = monitoring_default
    connect("area_entered", _on_area_entered)

func flip(current_direction: float) -> void:
    if current_direction < 0:
        scale.x = -1
    elif current_direction > 0:
        scale.x = 1

func die() -> void:
    set_deferred("monitoring", false)

func _on_area_entered(area: Area2D) -> void:
    if area is Hurtbox:
        var hurtbox: Hurtbox = area
        var direction := (hurtbox.global_position - global_position).normalized()
        hurtbox.on_hurtbox_hit(self, direction)
        emit_signal("hit")
        if contact_sound:
            SoundManager.play_sound_with_pitch(contact_sound, Rng.generate_random_pitch())
