extends State

class_name AirState

@export var double_jump_velocity: float = GameConstants.DOUBLE_JUMP_VELOCITY
@export var coyote_time: float = GameConstants.COYOTE_TIME
@onready var jump_buffer_timer: Timer = $Timer

var has_double_jumped: bool = false
var coyote_timer: float = 0

func on_enter() -> void:
	has_double_jumped = false
	coyote_timer = coyote_time

func state_physics_process(delta: float) -> void:
	coyote_timer -= delta

	if character.is_on_floor():
		emit_change_state("landing")
	elif character.velocity.y > 0:
		playback.travel("falling")

func state_input(event: InputEvent) -> void:
	if (event.is_action_pressed("jump")):
		if character.velocity.y > 0 && coyote_timer >= 0:
			emit_change_state("jump")
			return

		jump_buffer_timer.start()