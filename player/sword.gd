extends Area2D

@export var damage = 10

func _ready() -> void:
	monitoring = false

func _on_body_entered(body:Node2D) -> void:
	for child in body.get_children():
		if child is Damageable:
			print_debug(body.name + " took " + str(damage) + " damage")
			child.hit(damage)

