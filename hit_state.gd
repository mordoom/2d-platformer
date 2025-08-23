extends State

class_name HitState

@export var damageable: Damageable
@export var dead_state: State
@export var pursue_state: State
@export var knockback_speed: float = 20.0

var hit_direction

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_exit():
	character.velocity = Vector2.ZERO
	super.on_exit()

func on_damageable_hit(node: Node, amount: int, direction: Vector2):
	hit_direction = direction

	# TODO: find a better way to do knockback
	# character.velocity = knockback_speed * direction

	if (damageable.health > 0):
		emit_signal("interrupt_state", self)
		playback.travel("hit")
	else:
		emit_signal("interrupt_state", dead_state)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "hit"):
		next_state = pursue_state
		pursue_state.direction = sign(hit_direction.x)
