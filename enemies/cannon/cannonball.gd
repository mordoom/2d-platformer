extends CharacterBody2D

@export var speed = -200

var direction = Vector2.LEFT

func _physics_process(_delta: float) -> void:
	velocity = speed * direction

	move_and_slide()

	if (global_position.x <= 0):
		queue_free()
