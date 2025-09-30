class_name Enemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape = $CollisionShape2D
@onready var bt_player: BTPlayer = $BTPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var starting_point := position

@export var doubloons_dropped := 10
@export var death_anim_name: String
@export var stun_animation: StringName
@export var flying: bool = false
@export var components: Array[Node]
@export var perma_death := false

const hit_flash_shader = preload("res://characters/hitshader.tres")
var current_dir := Vector2.RIGHT
var current_speed := 0
var flash_time := 0.3
var player_check_offset := 50
var knockback_force = Vector2.ZERO
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var new_material := hit_flash_shader.duplicate()
	sprite.material = new_material
	bt_player.blackboard.bind_var_to_property(&"current_dir", self, &"current_dir", true)
	bt_player.blackboard.bind_var_to_property(&"current_speed", self, &"current_speed", true)
	bt_player.blackboard.bind_var_to_property(&"starting_point", self, &"starting_point", true)

	for component in components:
		if component is Hurtbox:
			component.connect("on_hit", _on_hurtbox_on_hit)
		elif component is HealthComponent:
			bt_player.blackboard.bind_var_to_property(&"health", component, &"health", true)
			component.connect("dead", _on_health_component_dead)

func _physics_process(delta):
	velocity.x = current_speed * current_dir.x + knockback_force.x
	if flying:
		velocity.y = current_speed * current_dir.y + knockback_force.y

	knockback_force = knockback_force.lerp(Vector2.ZERO, 0.2)

	if can_fall():
		velocity.y += gravity * delta

	update_facing_direction(current_dir.x)
	move_and_slide()

func can_fall() -> bool:
	return not is_on_floor() && not flying

func update_facing_direction(direction: float) -> void:
	for component in components:
		if component.has_method("flip"):
			component.flip(direction)

	if direction < 0:
		sprite.flip_h = true
		collision_shape.scale.x = -1
	elif direction > 0:
		sprite.flip_h = false
		collision_shape.scale.x = 1

func flip_direction() -> void:
	current_dir = - current_dir

func _on_health_component_dead() -> void:
	set_collision_layer_value(3, false)
	for component in components:
		if component.has_method("die"):
			component.die()
	bt_player.active = false
	current_speed = 0
	flying = false
	SignalBus.emit_signal("money_collected", null, doubloons_dropped)
	if perma_death:
		GameState.add_perma_dead_enemy(self)
	if death_anim_name:
		animation_player.play(death_anim_name)
	else:
		queue_free()

func _on_hurtbox_on_hit(damage: int, knockback_velocity: float, direction: Vector2, stun: bool) -> void:
	knockback_force = knockback_velocity * direction
	hit_flash()
	for component in components:
		if component is HealthComponent:
			var changed_health = component.health - damage
			if changed_health > 0:
					if stun:
						animation_player.play(stun_animation)
						await animation_player.animation_finished

	bt_player.blackboard.set_var(&"target", get_tree().get_first_node_in_group("Player"))

func hit_flash() -> void:
	sprite.material.set_shader_parameter("flash_value", 1.0)
	await get_tree().create_timer(flash_time).timeout
	sprite.material.set_shader_parameter("flash_value", 0)

func can_see_player() -> bool:
	for component in components:
		if component is EnvCheckComponent:
			return component.can_see_player()
	return false

func can_patrol() -> bool:
	for component in components:
		if component is EnvCheckComponent:
			return component.can_patrol()
	return true
