extends State

class_name LadderState

func on_enter():
	character.climbing = true
	character.set_collision_mask_value(1, false)
	character.global_position.x = character.on_ladder.global_position.x

func on_exit():
	character.climbing = false
	character.set_collision_mask_value(1, true)

func state_input(event):
	if event.is_action_pressed("jump"):
		emit_change_state("jump")

func state_process(_delta):
	if not character.climbing:
		character.set_collision_mask_value(1, true)
