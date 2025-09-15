class_name Enemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var wall_check: RayCast2D = $wall_check
@onready var floor_check: RayCast2D = $floor_check
@onready var player_check: RayCast2D = $player_check
@onready var bt_player: BTPlayer = $BTPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $HitboxComponent
@onready var hurtbox: Hurtbox = $Hurtbox

@export var doubloons_dropped := 10
@export var death_anim_name: String
@export var stun_animation: StringName

const hit_flash_shader = preload("res://new_characters/hitshader.tres")
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed := 0
var current_dir := 1
var flash_time := 0.3
var player_check_offset := 50
var knockback_force = Vector2.ZERO

func _ready():
	var new_material := hit_flash_shader.duplicate()
	sprite.material = new_material
	bt_player.blackboard.bind_var_to_property(&"current_dir", self, &"current_dir")
	bt_player.blackboard.bind_var_to_property(&"current_speed", self, &"current_speed")

func _physics_process(delta):
	velocity.x = current_speed * current_dir + knockback_force.x

	knockback_force = knockback_force.lerp(Vector2.ZERO, 0.2)

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

func flip_direction() -> void:
	var new_direction = current_dir * -1

	sprite.flip_h = false if new_direction > 0 else true

	wall_check.target_position.x = abs(wall_check.target_position.x) * new_direction
	wall_check.position.x = abs(wall_check.position.x) * new_direction

	floor_check.position.x = abs(floor_check.position.x) * new_direction

	player_check.target_position.y = abs(player_check.target_position.y) * new_direction

	hitbox.position.x = abs(hitbox.position.x) * new_direction

	current_dir = new_direction

func _on_health_component_dead() -> void:
	set_collision_layer_value(3, false)
	hurtbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	bt_player.active = false
	current_speed = 0
	animation_player.play(death_anim_name)
	SignalBus.emit_signal("money_collected", doubloons_dropped)

func _on_hurtbox_on_hit(_damage: int, knockback_velocity: float, direction: Vector2, stun: bool) -> void:
	knockback_force = knockback_velocity * direction
	hit_flash()
	if stun:
		animation_player.play(stun_animation)
		await animation_player.animation_finished

	bt_player.blackboard.set_var(&"target", get_tree().get_first_node_in_group("Player")) # TODO: if we passed the entire Hitbox Node instead we could assign the owner of the hitbox?
	bt_player.blackboard.set_var(&"current_dir", direction)

func hit_flash() -> void:
	sprite.material.set_shader_parameter("flash_value", 1.0)
	await get_tree().create_timer(flash_time).timeout
	sprite.material.set_shader_parameter("flash_value", 0)
