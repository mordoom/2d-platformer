extends State

class_name HitState

@export var damageable: Damageable
@export var knockback_speed: float = GameConstants.KNOCKBACK_SPEED

var hit_stop_time_scale = 0.1
var hit_stop_duration = 0.15

var hit_direction

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_exit():
	character.velocity = Vector2.ZERO


func on_damageable_hit(_node: Node, _amount: int, direction: Vector2):
	hit_direction = direction

	# TODO: find a better way to do knockback
	character.velocity = knockback_speed * direction

	if (damageable.is_dead()):
		emit_change_state("dead")
	else:
		emit_change_state("hit")
		playback.travel("hit")

	Engine.time_scale = hit_stop_time_scale
	await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
	Engine.time_scale = 1

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "hit" && get_parent().current_state == self):
		emit_reset_state()
