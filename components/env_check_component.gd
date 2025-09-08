class_name EnvCheckComponent
extends Node2D

@onready var floor_check: RayCast2D = $floor_check
@onready var wall_check: RayCast2D = $wall_check
@onready var player_check: RayCast2D = $player_check

var player_check_offset: float = 40

# Raycast caching for performance
var cached_floor_collision: bool = false
var cached_wall_collision: bool = false
var cached_player_collision: Node = null
var cache_timer: float = 0.0

func _process(delta):
    _update_raycast_cache(delta)

func _update_raycast_cache(delta: float) -> void:
    cache_timer -= delta

    if cache_timer <= 0:
        cache_timer = GameConstants.RAYCAST_CACHE_DURATION
        wall_check.force_raycast_update()
        floor_check.force_raycast_update()
        player_check.force_raycast_update()
    
    cached_floor_collision = floor_check.is_colliding()
    cached_wall_collision = wall_check.is_colliding()
    cached_player_collision = player_check.get_collider()

func flip(current_direction: float) -> void:
    wall_check.target_position.x = abs(wall_check.target_position.x) * current_direction
    wall_check.position.x = abs(wall_check.position.x) * current_direction

    floor_check.position.x = abs(floor_check.position.x) * current_direction

    player_check.position.x = (abs(player_check.position.x) * current_direction) - (player_check_offset * current_direction)
    player_check.target_position.x = abs(player_check.target_position.x) * current_direction

func can_patrol() -> bool:
    return cached_floor_collision && !cached_wall_collision