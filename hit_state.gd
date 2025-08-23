extends State

class_name HitState

@export var damageable: Damageable
@export var dead_state: State
@export var idle_state: State
@export var knockback_speed: float = 20.0

func _ready() -> void:
	damageable.connect("on_hit", on_damageable_hit)

func on_exit():
	character.velocity = Vector2.ZERO
	super.on_exit()

func on_damageable_hit(node: Node, amount: int, direction: Vector2):
	character.velocity = knockback_speed * direction

	if (damageable.health > 0):
		emit_signal("interrupt_state", self)
		playback.travel("hit")
	else:
		emit_signal("interrupt_state", dead_state)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "hit"):
		emit_signal("interrupt_state", idle_state)
