class_name EnvCheckComponent
extends Node2D

@onready var floor_check: RayCast2D = $floor_check
@onready var wall_check: RayCast2D = $wall_check
@onready var player_check = $player_check

func flip(current_direction: float) -> void:
    if current_direction < 0:
        wall_check.scale.x = -1
        floor_check.position.x = -15
        player_check.scale.x = -1
    elif current_direction > 0:
        wall_check.scale.x = 1
        floor_check.position.x = 15
        player_check.scale.x = 1

func can_patrol() -> bool:
    return floor_check.is_colliding() && not wall_check.is_colliding()

func can_see_player() -> bool:
    return player_check.is_colliding()