extends State

class_name PursueState

@onready var game_manager = get_tree().get_root().get_node("GameManager")
@export var chase_speed = GameConstants.SKELETON_CHASE_SPEED
@export var min_chase_distance = GameConstants.SKELETON_MIN_CHASE_DISTANCE
@export var max_chase_distance = GameConstants.SKELETON_MAX_CHASE_DISTANCE

func state_physics_process(_delta):
	var position_difference = game_manager.player_position.x - character.position.x
	var direction_to_player = sign(position_difference)
	var distance_to_player = abs(position_difference)
	var current_direction = character.get_current_direction()

	if direction_to_player != current_direction:
		character.set_direction(direction_to_player)

	if not character.can_patrol():
		emit_signal("on_change_state", "patrol")
		return

	if (distance_to_player > max_chase_distance):
		emit_signal("on_change_state", "patrol")
	elif (distance_to_player > min_chase_distance):
		character.velocity.x = direction_to_player * chase_speed
	else:
		character.velocity.x = 0
		emit_signal("on_change_state", "attack")
