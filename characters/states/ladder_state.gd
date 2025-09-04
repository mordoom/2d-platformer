extends State

class_name LadderState

func on_enter() -> void:
	character.climbing = true
	character.velocity.x = 0
	if character.on_ladder:
		character.global_position.x = character.on_ladder.global_position.x
		var climbable_comp: ClimbableComponent = character.on_ladder.get_node_or_null(GameConstants.ComponentNames.CLIMBABLE)
		if climbable_comp and climbable_comp.turn_off_collisions:
			character.set_collision_mask_value(1, false)

func on_exit() -> void:
	character.climbing = false
	character.set_collision_mask_value(1, true)

func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		emit_change_state("jump")

func state_process(_delta: float) -> void:
	if not character.climbing:
		character.set_collision_mask_value(1, true)
