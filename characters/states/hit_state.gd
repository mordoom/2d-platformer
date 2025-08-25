extends State

class_name HitState

@export var damageable: Damageable
@export var pursue: String
@export var knockback_speed: float = GameConstants.KNOCKBACK_SPEED

var hit_direction

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_exit():
	character.velocity = Vector2.ZERO
	super.on_exit()

func on_damageable_hit(_node: Node, _amount: int, direction: Vector2):
	hit_direction = direction

	# TODO: find a better way to do knockback
	character.velocity = knockback_speed * direction

	if (damageable.is_dead()):
		emit_signal("on_change_state", "dead")
	else:
		emit_signal("on_change_state", "hit")
		playback.travel("hit")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "hit"):
		emit_signal("on_change_state", pursue)

		if character.has_method("set_direction"):
			character.set_direction(sign(hit_direction.x))
