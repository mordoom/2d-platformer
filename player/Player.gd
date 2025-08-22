extends CharacterBody2D

@export var speed: float = 300.0
var current_speed = speed

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine = $CharacterStateMachine
@onready var sword_collision = $Sword/CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta	

	var direction = get_direction()
	if direction && state_machine.can_move():
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()

func get_direction():
	return Input.get_axis("left", "right")

func _input(_event: InputEvent) -> void:
	var direction = get_direction()
	update_animation(direction)
	update_facing_direction(direction)

func update_animation(direction: float = 0):
	animation_tree.set("parameters/move/blend_position", direction)

func update_facing_direction(direction: float):
	if direction < 0:
		sprite.flip_h = true
		if sign(sword_collision.position.x) == 1:
			sword_collision.position.x *= -1
	elif direction > 0:
		sprite.flip_h = false
		if sign(sword_collision.position.x) == -1:
			sword_collision.position.x *= -1
