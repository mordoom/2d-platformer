class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var input_manager: InputManager = $InputManager
@onready var bullet_path: RayCast2D = $BulletPath
@onready var hurtbox: Hurtbox = $HurtboxComponent
@onready var hitbox: Hitbox = $Hitbox
@onready var deflect_box: DeflectBox = $DeflectBox
@onready var health_component: HealthComponent = $HealthComponent
@onready var interact_area: Area2D = $InteractArea
@onready var hsm: LimboHSM = $LimboHSM

@export var movement_speed := 250.0
@export var roll_speed := 400.0
@export var ladder_speed := 150.0

@export var jump_height := 100.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_descend := 0.5
@export var coyote_time := 0.1
@export var variable_height_jump_mult := 0.2

@onready var jump_velocity := ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity := ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity := ((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) * -1.0

var current_direction := 1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir := Vector2.ZERO
var current_speed := 0
var knockback_force = Vector2.ZERO
var roll_force = 0
var climbing = false
var double_jumped = false
var rum_bottles: int = 0
var max_rum_bottles: int = 0
var climbable_above: Area2D = null
var climbable_below: Area2D = null
var swingable_above: Area2D = null

func _ready() -> void:
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.dir_var, self, &"dir")
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.current_speed_var, self, &"current_speed")
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.roll_force_var, self, &"roll_force")
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.climbing_var, self, &"climbing")
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.has_double_jumped_var, self, &"double_jumped")
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.climbable_above_var, self, &"climbable_above")
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.climbable_below_var, self, &"climbable_below")
    hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.swingable_above_var, self, &"swingable_above")
    on_enter()

func on_enter() -> void:
    pass

func _physics_process(delta: float) -> void:
    if is_on_floor():
        double_jumped = false
    elif not climbing:
        velocity.y += calc_gravity() * delta

    var can_move: bool = hsm.blackboard.get_var(GameConstants.BlackboardVars.can_move_var)

    if climbing:
        velocity.y = ladder_speed * dir.y

    if is_on_ceiling():
        InputBuffer._invalidate_action("jump")

    velocity.x = dir.x * current_speed + knockback_force.x + roll_force

    if can_move:
        update_facing_direction(dir.x)
    
    knockback_force = knockback_force.lerp(Vector2.ZERO, 0.2)
    move_and_slide()

func calc_gravity() -> float:
    return jump_gravity if velocity.y < 0 else fall_gravity

func update_facing_direction(direction: float) -> void:
    if direction < 0:
        current_direction = sign(direction)
        sprite.flip_h = true
        bullet_path.rotation_degrees = 90
        hitbox.scale.x = -1
        deflect_box.scale.x = -1
    elif direction > 0:
        current_direction = sign(direction)
        sprite.flip_h = false
        bullet_path.rotation_degrees = 270
        hitbox.scale.x = 1
        deflect_box.scale.x = 1

func handle_interactions():
    for area: Area2D in interact_area.get_overlapping_areas():
        var interaction_comp: InteractionComponent = area.get_node_or_null(GameConstants.ComponentNames.INTERACTION)
        var collection_comp: CollectionComponent = area.get_node_or_null(GameConstants.ComponentNames.COLLECTION)
        if interaction_comp:
            interaction_comp.interact()
        if collection_comp:
            collection_comp.collect()

func add_rum_bottle() -> void:
    rum_bottles = rum_bottles + 1
    max_rum_bottles = max_rum_bottles + 1

func was_hit() -> void:
    hsm.dispatch(&"hit_started")

func die() -> void:
    hsm.dispatch(&"death_started")

func set_health(value: int) -> void:
    health_component.health = value

func get_health() -> int:
    return health_component.health

func _on_climbable_area_above_area_entered(area: Area2D) -> void:
    if area is Climbable:
        climbable_above = area
    elif area is SwingRope:
        swingable_above = area

func _on_climbable_area_above_area_exited(area: Area2D) -> void:
    if area is Climbable:
        climbable_above = null
    elif area is SwingRope:
        swingable_above = null

func _on_climbable_area_below_area_entered(area: Area2D) -> void:
    if area is Climbable:
        climbable_below = area

func _on_climbable_area_below_area_exited(area: Area2D) -> void:
    if area is Climbable:
        climbable_below = null

func _on_health_component_dead() -> void:
    hsm.dispatch(&"death_started")

func _on_hurtbox_component_on_hit(_damage: int, knockback_velocity: float, direction: Vector2, _stun: bool) -> void:
    knockback_force = knockback_velocity * direction
    hsm.dispatch(&"hit_started")
