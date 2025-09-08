extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var sprite: Sprite2D = $Sprite2D

@onready var gravity_comp: GravityComponent = $GravityComponent
@onready var damage_area: DamageArea = $AttackArea

@onready var healthbar: BossHealthbar = $BossHealthbar
@onready var damageable: DamageableComponent = $DamageableComponent

@export var components: Array[Node2D]

var current_direction: float = 1.0

func _ready() -> void:
	animation_tree.active = true
	if GameState.enemy_is_dead(self):
		queue_free()
		return
	damageable.connect("on_hit", on_damageable_hit)

func _physics_process(delta: float) -> void:
	gravity_comp.add_gravity(delta)

	if (state_machine.is_dead()):
		return

	var direction: float = sign(velocity.x)
	animation_tree.set("parameters/patrol/blend_position", direction)
	if (state_machine.can_move()):
		move_and_slide()

func set_direction(new_direction: float) -> void:
	if new_direction != current_direction:
		current_direction = new_direction
		sprite.flip_h = false if current_direction > 0 else true
		for component in components:
			if component.has_method("flip"):
				component.flip(current_direction)

func can_patrol() -> bool:
	return true

func on_damageable_hit(_node: Node, _damage_taken: int, _direction: Vector2) -> void:
	if (damageable.is_dead()):
		healthbar.dead()
		GameState.add_perma_dead_enemy(self)
		set_collision_layer_value(1, false)
