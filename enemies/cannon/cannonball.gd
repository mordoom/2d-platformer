extends CharacterBody2D

@export var speed = -200

var direction = Vector2.LEFT
var in_motion = false
var initial_position: Vector2

func _ready():
	initial_position = global_position

func _physics_process(_delta: float) -> void:
	if not in_motion:
		return

	velocity = speed * direction

	move_and_slide()

	if (global_position.x <= 0):
		reset()

func reset():
	global_position = initial_position
	in_motion = false