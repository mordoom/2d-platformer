extends State

class_name HitState

@export var interrupt: bool = true
@export var damageable: DamageableComponent
@export var knockback_speed: float = GameConstants.KNOCKBACK_SPEED

var hit_stop_time_scale: float = 0.1
var hit_stop_duration: float = 0.2

var hit_direction: Vector2

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_exit() -> void:
	character.velocity.x = 0

func on_damageable_hit(_node: Node, _amount: int, direction: Vector2) -> void:
	hit_direction = direction

	# TODO: find a better way to do knockback
	character.velocity = knockback_speed * direction

	if (damageable.is_dead()):
		emit_change_state("dead")
	elif interrupt:
		emit_change_state("hit")
		playback.travel("hit")

	Engine.time_scale = hit_stop_time_scale
	await get_tree().create_timer(hit_stop_duration * hit_stop_time_scale).timeout
	Engine.time_scale = 1

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "hit" && get_parent().current_state == self):
		emit_reset_state()
