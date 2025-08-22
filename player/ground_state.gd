extends State

class_name GroundState

@export var air_state: State
@export var ground_attack_state: State
@export var jump_velocity = -400.0

var jump_dust_anim = preload("res://jump_dust_anim.tscn")

func on_enter():
	playback.travel("move")

func state_input(event: InputEvent):
	if event.is_action_pressed("jump"):
		jump()
	elif event.is_action_pressed("attack"):
		attack()
		
func state_process(_delta):
	if (!player.is_on_floor()):
		next_state = air_state

func attack():
	next_state = ground_attack_state

func jump():
	player.velocity.y = jump_velocity

	var jump_dust = jump_dust_anim.instantiate()
	get_tree().get_root().add_child(jump_dust)
	jump_dust.global_position = player.global_position

	next_state = air_state
	playback.travel("jump")
