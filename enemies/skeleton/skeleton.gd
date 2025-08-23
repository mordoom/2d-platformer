extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = $CharacterStateMachine
@onready var sprite = $Sprite2D
@onready var sword_collision = $AttackArea/CollisionShape2D

# Raycast nodes
@onready var floor_check: RayCast2D = $floor_check
@onready var wall_check: RayCast2D = $wall_check
@onready var player_check: RayCast2D = $player_check

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_direction: float = 1.0

# Raycast caching for performance
var cached_floor_collision: bool = false
var cached_wall_collision: bool = false
var cached_player_collision: Node = null
var cache_timer: float = 0.0

func _ready() -> void:
    animation_tree.active = true

func _physics_process(delta: float) -> void:
    _update_raycast_cache(delta)
    
    if not is_on_floor():
        velocity.y += gravity * delta

    var direction = get_direction()
    update_facing_direction(direction)
    update_animation(direction)
    if (state_machine.can_move()):
        move_and_slide()

func _update_raycast_cache(delta: float):
    cache_timer -= delta
    if cache_timer <= 0:
        cache_timer = GameConstants.RAYCAST_CACHE_DURATION
        
        wall_check.force_raycast_update()
        floor_check.force_raycast_update()
        player_check.force_raycast_update()
        
        cached_floor_collision = floor_check.is_colliding()
        cached_wall_collision = wall_check.is_colliding()
        cached_player_collision = player_check.get_collider()

func can_patrol() -> bool:
    return cached_floor_collision && !cached_wall_collision

func get_player_collision() -> Node:
    return cached_player_collision

func set_direction(new_direction: float):
    if new_direction != current_direction:
        current_direction = new_direction
        _flip_raycasts()

func get_current_direction() -> float:
    return current_direction

func _flip_raycasts():
    wall_check.target_position.x = abs(wall_check.target_position.x) * current_direction
    wall_check.position.x = abs(wall_check.position.x) * current_direction
    floor_check.position.x = abs(floor_check.position.x) * current_direction
    player_check.position.x = abs(player_check.position.x) * current_direction
    player_check.target_position.x = abs(player_check.target_position.x) * current_direction

func get_direction():
    return sign(velocity.x)

func update_animation(direction: float):
    animation_tree.set("parameters/patrol/blend_position", direction)

func update_facing_direction(direction: float):
    if direction < 0:
        sprite.flip_h = true
        if sign(sword_collision.position.x) == 1:
            sword_collision.position.x *= -1
    elif direction > 0:
        sprite.flip_h = false
        if sign(sword_collision.position.x) == -1:
            sword_collision.position.x *= -1
