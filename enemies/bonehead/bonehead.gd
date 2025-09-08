extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_collision: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var damageable: Damageable = $Damageable
@onready var healthbar: BossHealthbar = $BossHealthbar

@onready var floor_check: RayCast2D = $floor_check
@onready var wall_check: RayCast2D = $wall_check
@onready var player_check: RayCast2D = $player_check

@onready var projectile_comp: Node = $ProjectileComponent

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_direction: float = 1.0
var player_check_offset: float = 40
var climbing: bool = false

# Raycast caching for performance
var cached_floor_collision: bool = false
var cached_wall_collision: bool = false
var cached_player_collision: Node = null
var cache_timer: float = 0.0

func _ready() -> void:
    animation_tree.active = true
    damageable.connect("on_hit", on_damageable_hit)
    if GameState.enemy_is_dead(self):
        queue_free()
        return

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta

    if (state_machine.is_dead()):
        healthbar.dead()
        return

    _update_raycast_cache(delta)

    var direction: float = get_movement_direction()
    update_animation(direction)
    if (state_machine.can_move()):
        move_and_slide()

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

func can_patrol() -> bool:
    return true

func get_player_collision() -> Node:
    return cached_player_collision

func set_direction(new_direction: float) -> void:
    if new_direction != current_direction:
        current_direction = new_direction
        _flip_raycasts()
        projectile_comp.position.x = abs(projectile_comp.position.x) * current_direction
        projectile_comp.transform.x = abs(projectile_comp.transform.x) * current_direction
        update_facing_direction(new_direction)

func get_current_direction() -> float:
    return current_direction

func _flip_raycasts() -> void:
    wall_check.target_position.x = abs(wall_check.target_position.x) * current_direction
    wall_check.position.x = abs(wall_check.position.x) * current_direction

    floor_check.position.x = abs(floor_check.position.x) * current_direction

    player_check.position.x = (abs(player_check.position.x) * current_direction) - (player_check_offset * current_direction)
    player_check.target_position.x = abs(player_check.target_position.x) * current_direction

    sword_collision.position.x = abs(sword_collision.position.x) * current_direction

func get_movement_direction() -> float:
    return sign(velocity.x)

func update_animation(direction: float) -> void:
    animation_tree.set("parameters/patrol/blend_position", direction)

func update_facing_direction(direction: float) -> void:
    sprite.flip_h = false if direction > 0 else true

func on_damageable_hit(_node: Node, _damage_taken: int, _direction: Vector2) -> void:
    if (damageable.is_dead()):
        GameState.add_perma_dead_enemy(self)
        set_collision_layer_value(1, false)
