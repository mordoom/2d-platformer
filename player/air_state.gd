extends State

class_name AirState

@export var landing_state: State
@export var jump_state: State
@export var double_jump_velocity: float = GameConstants.DOUBLE_JUMP_VELOCITY
@export var coyote_time: float = GameConstants.COYOTE_TIME
@onready var jump_buffer_timer = $Timer

var jump_dust_anim = preload("res://effects/jump_dust_anim.tscn")
var has_double_jumped = false
var coyote_timer: float = 0

func on_enter():
	has_double_jumped = false
	coyote_timer = coyote_time

func state_physics_process(delta):
	coyote_timer -= delta

	if character.is_on_floor():
		if jump_buffer_timer.is_stopped():
			playback.travel("landing")
			emit_signal("on_change_state", "landing")
		else:
			jump_buffer_timer.stop()
			emit_signal("on_change_state", "jump")
	
	if character.velocity.y > 0:
		playback.travel("falling")

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump")):
		if character.velocity.y > 0 && coyote_timer >= 0:
			emit_signal("on_change_state", "jump")
			return

		jump_buffer_timer.start()