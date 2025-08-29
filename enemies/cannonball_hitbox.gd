extends Area2D

# TODO: this is a copy of the weapon script, try to remove. the only difference is the ready function

@export var damage = GameConstants.CANNONBALL_DAMAGE

func _ready() -> void:
    monitoring = true

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

            # TODO: generate an explosion effect
            get_parent().queue_free()
