class_name CharacterState
extends LimboState

@onready var hsm: LimboHSM = get_parent()

@export var can_move: bool = true
@export var animation_player: AnimationPlayer
@export var animation_name: StringName

func _enter() -> void:
	animation_player.play(animation_name)
	blackboard.set_var(GameConstants.BlackboardVars.can_move_var, can_move)

func _update(_delta: float) -> void:
	if not animation_player.is_playing() or animation_player.assigned_animation != animation_name:
		dispatch(EVENT_FINISHED)
