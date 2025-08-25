extends State

class_name GroundState

@export var air_state: State
@export var jump_state: State
@export var ground_attack_state: State

# TODO: this is required for the hit state atm
var direction

func on_enter():
	playback.travel("move")

func state_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		emit_signal("on_change_state", jump_state)
	elif event.is_action_pressed("attack"):
		attack()
		
func state_process(_delta):
	if not character.is_on_floor():
		emit_signal("on_change_state", air_state)

func attack():
	emit_signal("on_change_state", ground_attack_state)
