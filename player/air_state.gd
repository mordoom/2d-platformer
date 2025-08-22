extends State

class_name AirState

@export var landing_state: State
@export var double_jump_velocity: float = -300
@export var coyote_time: float = 0.1
@onready var jump_buffer_timer = $Timer

var has_double_jumped = false
var coyote_timer: float = 0

func on_enter():
	coyote_timer = coyote_time

func state_process(delta):
	coyote_timer -= delta

	if player.is_on_floor():
		if jump_buffer_timer.is_stopped():
			playback.travel("landing")
			next_state = landing_state
		else:
			jump_buffer_timer.stop()
			player.velocity.y = double_jump_velocity
			playback.travel("jump")
			has_double_jumped = false
	
	if player.velocity.y > 0:
		playback.travel("falling")

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump")):
		if player.velocity.y > 0 && coyote_timer >= 0:
			player.velocity.y = double_jump_velocity
			playback.travel("jump")
			return

		if not has_double_jumped:
			double_jump()
		else:
			jump_buffer_timer.start()

func double_jump():
	player.velocity.y = double_jump_velocity
	has_double_jumped = true
	playback.travel("jump")

func on_exit():
	if (next_state == landing_state):
		has_double_jumped = false
	super.on_exit()
