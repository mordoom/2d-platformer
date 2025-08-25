extends State

class_name GroundState

func on_enter():
	playback.travel("move")

func state_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		emit_signal("on_change_state", "jump")
	elif event.is_action_pressed("attack"):
		emit_signal("on_change_state", "groundattack")
		
func state_physics_process(_delta):
	if not character.is_on_floor():
		emit_signal("on_change_state", "air")
