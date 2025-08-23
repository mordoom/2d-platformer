extends State

class_name PursueState

@onready var player = GameManager.player

@export var chase_speed = 70
@export var patrol_state: State
@export var attack_state: State
@export var minChaseDifference = 50
@export var maxChaseDifference = 500

var floor_check: RayCast2D
var wall_check: RayCast2D
var player_check: RayCast2D
var direction

func on_enter():
	floor_check = character.get_node("floor_check")
	wall_check = character.get_node("wall_check")
	player_check = character.get_node("player_check")

func state_physics_process(_delta):
	wall_check.force_raycast_update()
	floor_check.force_raycast_update()
	
	var position_difference = player.position.x - character.position.x
	var direction_to_player = sign(position_difference)
	var distance_to_player = abs(position_difference)

	if direction_to_player != direction:
		flip_direction()

	var can_pursue = floor_check.is_colliding() && !wall_check.is_colliding()
	if !can_pursue:
		next_state = patrol_state
		patrol_state.direction = direction
		return

	if (distance_to_player > maxChaseDifference):
		next_state = patrol_state
		patrol_state.direction = direction
	elif (distance_to_player > minChaseDifference):
		character.velocity.x = direction_to_player * chase_speed
	else:
		character.velocity.x = 0
		next_state = attack_state

func flip_direction():
	direction *= -1
	wall_check.target_position *= -1
	wall_check.position.x *= -1
	floor_check.position.x *= -1
	player_check.position.x *= -1
	player_check.target_position *= -1
