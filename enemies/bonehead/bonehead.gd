extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var healthbar: BossHealthbar = $BossHealthbar
@onready var damageable: DamageableComponent = $DamageableComponent

@onready var damage_area: DamageArea = $AttackArea
@onready var projectile_comp: ProjectileComponent = $ProjectileComponent
@onready var env_check_comp: EnvCheckComponent = $EnvCheckComponent

@export var components: Array[Node2D]

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_direction: float = 1.0
var climbing: bool = false

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

	var direction: float = get_movement_direction()
	update_animation(direction)
	if (state_machine.can_move()):
		move_and_slide()

func can_patrol() -> bool:
	return true

func set_direction(new_direction: float) -> void:
	if new_direction != current_direction:
		current_direction = new_direction
		for component in components:
			if component.has_method("flip"):
				component.flip(current_direction)
		update_facing_direction(new_direction)

func get_player_collision() -> Node:
	return env_check_comp.cached_player_collision

func get_current_direction() -> float:
	return current_direction

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
