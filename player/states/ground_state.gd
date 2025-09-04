extends State

class_name GroundState

func on_enter() -> void:
	playback.travel("move")

func state_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") || InputBuffer.is_action_press_buffered("jump"):
		emit_change_state("jump")
	elif Input.is_action_just_pressed("attack"):
		emit_change_state("groundattack")
		
func state_physics_process(_delta: float) -> void:
	if not character.is_on_floor():
		emit_change_state("air")
