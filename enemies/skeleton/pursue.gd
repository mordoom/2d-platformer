extends State

class_name PursueState

@export var chase_speed: float = GameConstants.SKELETON_CHASE_SPEED
@export var min_chase_distance: float = GameConstants.SKELETON_MIN_CHASE_DISTANCE
@export var max_chase_distance: float = GameConstants.SKELETON_MAX_CHASE_DISTANCE

func state_physics_process(_delta: float) -> void:
	var player: Node = get_tree().get_first_node_in_group("Player")
	if (player == null):
		emit_change_state("patrol")
		return

	var position_difference: float = player.position.x - character.position.x
	var direction_to_player: float = sign(position_difference)
	var distance_to_player: float = abs(position_difference)
	var current_direction: float = character.current_direction

	if direction_to_player != current_direction:
		character.set_direction(direction_to_player)

	if not character.can_patrol():
		emit_change_state("patrol")
		return

	if (distance_to_player > max_chase_distance):
		emit_change_state("patrol")
	elif (distance_to_player > min_chase_distance):
		character.velocity.x = direction_to_player * chase_speed
	else:
		character.velocity.x = 0
		emit_change_state("attack")
