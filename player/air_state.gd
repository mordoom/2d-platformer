extends State

class_name AirState

@export var landing_state: State
@export var double_jump_velocity: float = -300
var has_double_jumped = false

func state_process(_delta):
	if player.is_on_floor():
		playback.travel("landing")
		next_state = landing_state
	
	if player.velocity.y > 0:
		playback.travel("falling")

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump") && !has_double_jumped):
		double_jump()
		
func double_jump():
	player.velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel("jump")

func on_exit():
	if (next_state == landing_state):
		has_double_jumped = false
	super.on_exit()
