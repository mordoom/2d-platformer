extends Node

var rum_bottles: Array[String] = []
var perma_dead_enemies: Array[String] = []
var dead_enemies: Array[String] = []

func reset_enemies() -> void:
    dead_enemies = []

func enemy_is_dead(enemy: Node2D) -> bool:
    var unique_key: String = get_enemy_unique_key(enemy)
    return unique_key in perma_dead_enemies || unique_key in dead_enemies

func add_perma_dead_enemy(enemy: Node2D) -> void:
    perma_dead_enemies.append(get_enemy_unique_key(enemy))

func add_dead_enemy(enemy: Node2D) -> void:
    dead_enemies.append(get_enemy_unique_key(enemy))

func get_enemy_unique_key(enemy: Node2D) -> String:
    return enemy.get_parent().scene_file_path + str(enemy.get_path())

func is_rum_bottle_collected(node: Node2D) -> bool:
    var unique_key: String = get_enemy_unique_key(node)
    return unique_key in rum_bottles

func rum_bottle_collected(node: Node2D) -> void:
    var unique_key: String = get_enemy_unique_key(node)
    rum_bottles.append(unique_key)
