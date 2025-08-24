extends Area2D
class_name Weapon

@export var damage = GameConstants.SWORD_DAMAGE

func _ready() -> void:
	monitoring = false

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is Damageable:
			print_debug(body.name + " took " + str(damage) + " damage")
			var direction_to_target = body.global_position - get_parent().global_position
			var direction_sign = sign(direction_to_target.x)
			var damage_direction = Vector2.ZERO
			
			if direction_sign > 0:
				damage_direction = Vector2.RIGHT
			elif direction_sign < 0:
				damage_direction = Vector2.LEFT
			
			child.hit(damage, damage_direction)