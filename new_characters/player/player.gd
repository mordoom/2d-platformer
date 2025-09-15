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
@onready var idle_state: LimboState = $LimboHSM/Idle
@onready var move_state: LimboState = $LimboHSM/Move
@onready var run_attack_state: LimboState = $LimboHSM/RunAttack
@onready var roll_state: LimboState = $LimboHSM/Roll
@onready var attack_state: LimboState = $LimboHSM/GroundAttack
@onready var jump_state: LimboState = $LimboHSM/Jump
@onready var jump_attack_state: LimboState = $LimboHSM/JumpAttack
@onready var air_state: LimboState = $LimboHSM/Air
@onready var climbing_state: LimboState = $LimboHSM/Climbing
@onready var swinging_state: LimboState = $LimboHSM/Swinging
@onready var hit_state: LimboState = $LimboHSM/Hit
@onready var dead_state: LimboState = $LimboHSM/Dead
@onready var shoot_state: LimboState = $LimboHSM/Shoot
@onready var deflect_state: LimboState = $LimboHSM/Deflect

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

func _ready() -> void:
	_init_state_machine()
	hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.dir_var, self, &"dir")
	hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.current_speed_var, self, &"current_speed")
	hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.roll_force_var, self, &"roll_force")
	hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.climbing_var, self, &"climbing")
	hsm.blackboard.bind_var_to_property(GameConstants.BlackboardVars.has_double_jumped_var, self, &"double_jumped")
	on_enter()

func on_enter() -> void:
	pass

func _init_state_machine() -> void:
	hsm.blackboard.set_var(GameConstants.BlackboardVars.climbable_above_var, null)
	hsm.blackboard.set_var(GameConstants.BlackboardVars.climbable_below_var, null)

	hsm.add_transition(idle_state, move_state, &"movement_started")
	hsm.add_transition(move_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(move_state, roll_state, &"roll_started")
	hsm.add_transition(roll_state, move_state, hsm.EVENT_FINISHED)

	hsm.add_transition(idle_state, attack_state, &"ground_attack_started")
	hsm.add_transition(attack_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(idle_state, deflect_state, &"deflect_started")
	hsm.add_transition(deflect_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(idle_state, shoot_state, &"shoot_started")
	hsm.add_transition(shoot_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(move_state, run_attack_state, &"run_attack_started")
	hsm.add_transition(run_attack_state, move_state, hsm.EVENT_FINISHED)

	hsm.add_transition(idle_state, jump_state, &"jump_started")
	hsm.add_transition(move_state, jump_state, &"jump_started")
	hsm.add_transition(jump_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(idle_state, air_state, &"fall_started")
	hsm.add_transition(move_state, air_state, &"fall_started")
	hsm.add_transition(air_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(air_state, jump_attack_state, &"jump_attack_started")
	hsm.add_transition(air_state, jump_state, &"jump_started")
	hsm.add_transition(jump_state, jump_attack_state, &"jump_attack_started")
	hsm.add_transition(jump_attack_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(idle_state, climbing_state, &"climb_started")
	hsm.add_transition(jump_state, climbing_state, &"climb_started")
	hsm.add_transition(air_state, climbing_state, &"climb_started")
	hsm.add_transition(climbing_state, jump_state, &"jump_started")
	hsm.add_transition(climbing_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(jump_state, swinging_state, &"swing_started")
	hsm.add_transition(air_state, swinging_state, &"swing_started")
	hsm.add_transition(swinging_state, jump_state, &"jump_started")
	hsm.add_transition(swinging_state, air_state, &"fall_started")
	hsm.add_transition(swinging_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(hsm.ANYSTATE, hit_state, &"hit_started")
	hsm.add_transition(hit_state, idle_state, hsm.EVENT_FINISHED)

	hsm.add_transition(hsm.ANYSTATE, dead_state, &"death_started")

	hsm.initialize(self)
	hsm.set_active(true)

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
		hsm.blackboard.set_var(GameConstants.BlackboardVars.climbable_above_var, area)
	elif area is SwingRope:
		hsm.blackboard.set_var(GameConstants.BlackboardVars.swingable_above_var, area)

func _on_climbable_area_above_area_exited(area: Area2D) -> void:
	if area is Climbable:
		hsm.blackboard.set_var(GameConstants.BlackboardVars.climbable_above_var, null)
	elif area is SwingRope:
		hsm.blackboard.set_var(GameConstants.BlackboardVars.swingable_above_var, null)

func _on_climbable_area_below_area_entered(area: Area2D) -> void:
	if area is Climbable:
		hsm.blackboard.set_var(GameConstants.BlackboardVars.climbable_below_var, area)

func _on_climbable_area_below_area_exited(area: Area2D) -> void:
	if area is Climbable:
		hsm.blackboard.set_var(GameConstants.BlackboardVars.climbable_below_var, null)

func _on_health_component_dead() -> void:
	hsm.dispatch(&"death_started")

func _on_hurtbox_component_on_hit(_damage: int, knockback_velocity: float, direction: Vector2, _stun: bool) -> void:
	knockback_force = knockback_velocity * direction
	hsm.dispatch(&"hit_started")

func add_rum_bottle() -> void:
	rum_bottles = rum_bottles + 1
	max_rum_bottles = max_rum_bottles + 1
