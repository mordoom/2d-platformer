extends Node

class_name Damageable

@export var health = 30

func hit(damage: int):
    health -= damage
    if health <= 0:
        get_parent().queue_free()
        print_debug(get_parent().name + " died")