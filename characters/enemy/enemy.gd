class_name Enemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var wall_check: RayCast2D = $wall_check
@onready var floor_check: RayCast2D = $floor_check
@onready var player_check = $player_check
@onready var bt_player: BTPlayer = $BTPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $HitboxComponent
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var collision_shape = $CollisionShape2D

@onready var starting_point := position
@export var projectile_component: ProjectileComponent
@export var doubloons_dropped := 10
@export var death_anim_name: String
@export var stun_animation: StringName
@export var flying: bool = false

const hit_flash_shader = preload("res://characters/hitshader.tres")
var current_dir := Vector2.RIGHT
var current_speed := 0
var flash_time := 0.3
var player_check_offset := 50
var knockback_force = Vector2.ZERO
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var dead := false

func _ready():
	var new_material := hit_flash_shader.duplicate()
	sprite.material = new_material
	bt_player.blackboard.bind_var_to_property(&"current_dir", self, &"current_dir")
	bt_player.blackboard.bind_var_to_property(&"current_speed", self, &"current_speed")
	bt_player.blackboard.bind_var_to_property(&"starting_point", self, &"starting_point", true)
	hurtbox.connect("on_hit", _on_hurtbox_on_hit)
	health_component.connect("dead", _on_health_component_dead)

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
	if direction < 0:
		sprite.flip_h = true
		hitbox.scale.x = -1
		hurtbox.scale.x = -1
		wall_check.scale.x = -1
		floor_check.position.x = -15
		player_check.scale.x = -1
		collision_shape.scale.x = -1
	elif direction > 0:
		sprite.flip_h = false
		hitbox.scale.x = 1
		hurtbox.scale.x = 1
		wall_check.scale.x = 1
		floor_check.position.x = 15
		player_check.scale.x = 1
		collision_shape.scale.x = 1

func flip_direction() -> void:
	current_dir = - current_dir
	if projectile_component:
		projectile_component.flip(current_dir.x)

func _on_health_component_dead() -> void:
	set_collision_layer_value(3, false)
	hurtbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	bt_player.active = false
	current_speed = 0
	flying = false
	dead = true
	SignalBus.emit_signal("money_collected", null, doubloons_dropped)
	if death_anim_name:
		animation_player.play(death_anim_name)
	else: queue_free()

func _on_hurtbox_on_hit(_damage: int, knockback_velocity: float, direction: Vector2, stun: bool) -> void:
	knockback_force = knockback_velocity * direction
	hit_flash()
	if stun:
		animation_player.play(stun_animation)
		await animation_player.animation_finished

	bt_player.blackboard.set_var(&"target", get_tree().get_first_node_in_group("Player"))

func hit_flash() -> void:
	sprite.material.set_shader_parameter("flash_value", 1.0)
	await get_tree().create_timer(flash_time).timeout
	sprite.material.set_shader_parameter("flash_value", 0)
