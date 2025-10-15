class_name Hurtbox
extends Area2D

@export var deflect_box: DeflectBox
@export var cooldown_time := 0.1

var hit_stop_time_scale := 0.1
@export var hit_stop_duration := 0.2
var cooldown_timer: Timer

func _ready():
    cooldown_timer = Timer.new()
    cooldown_timer.wait_time = cooldown_time
    cooldown_timer.one_shot = true
    add_child(cooldown_timer)

signal on_hit(damage: int, knockback_velocity: float, direction: Vector2, stun: bool)

func on_hurtbox_hit(hitbox: Hitbox, direction: Vector2) -> void:
    if not cooldown_timer.is_stopped():
        return

    cooldown_timer.start()

    apply_hitstop()

    if deflect_box != null:
        if deflect_box.is_deflecting && sign(direction.x) != owner.current_direction:
            deflect_box.deflect()
            owner.apply_knockback_force(hitbox.knockback_velocity / 2, direction)
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

func apply_hitstop() -> void:
    Engine.time_scale = hit_stop_time_scale
    await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
    Engine.time_scale = 1