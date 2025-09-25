class_name Hurtbox
extends Area2D

@export var deflect_box: DeflectBox

var hit_stop_time_scale := 0.1
var hit_stop_duration := 0.2

signal on_hit(damage: int, knockback_velocity: float, direction: Vector2, stun: bool)

func on_hurtbox_hit(hitbox: Hitbox, direction: Vector2) -> void:
	Engine.time_scale = hit_stop_time_scale
	await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
	Engine.time_scale = 1

	if deflect_box != null:
		if deflect_box.is_deflecting && direction.x != owner.current_direction:
			deflect_box.deflect()
			if hitbox.owner.get("animation_player"):
				hitbox.owner.animation_player.stop()
			return
	emit_signal("on_hit", hitbox.damage, hitbox.knockback_velocity, direction, hitbox.stun)

func flip(current_direction: float) -> void:
	if current_direction < 0:
		scale.x = -1
	elif current_direction > 0:
		scale.x = 1

func die() -> void:
	set_deferred("monitorable", false)
