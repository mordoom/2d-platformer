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

func _input(event):
	if (Input.is_action_pressed("up")):
		if character.is_raycast_on_ceiling():
			if not character.climbing && character.on_ladder:
				emit_change_state("ladder")
		else:
			if character.climbing:
				emit_change_state("ground")
	elif (Input.is_action_pressed("down")):
		if character.is_raycast_on_floor():
			if not character.climbing && character.on_ladder:
				emit_change_state("ladder")
		else:
			if character.climbing:
				emit_change_state("ground")
