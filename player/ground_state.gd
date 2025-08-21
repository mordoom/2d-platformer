extends State

class_name GroundState

@export var air_state: State
@export var jump_velocity = -400.0

func state_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		jump()
		
func state_process(delta):
	if (!player.is_on_floor()):
		next_state = air_state

func jump():
	player.velocity.y = jump_velocity
	next_state = air_state
	playback.travel("jump")
