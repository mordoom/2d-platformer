extends Area2D
class_name DamageArea

@onready var collision_object: CollisionShape2D = $CollisionShape2D

@export var damage: int = GameConstants.SWORD_DAMAGE
@export var initial_monitoring_state: bool = true

signal on_damage_area_hit()

func _ready() -> void:
	monitoring = initial_monitoring_state

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is DamageableComponent:
			print_debug(body.name + " took " + str(damage) + " damage")
			var direction_to_target: Vector2 = body.global_position - get_parent().global_position
			var direction_sign: float = sign(direction_to_target.x)
			var damage_direction: Vector2 = Vector2.ZERO
			
			if direction_sign > 0:
				damage_direction = Vector2.RIGHT
			elif direction_sign < 0:
				damage_direction = Vector2.LEFT
			
			child.hit(damage, damage_direction)
			emit_signal("on_damage_area_hit")

func flip(current_direction: float) -> void:
	collision_object.position.x = abs(collision_object.position.x) * current_direction
