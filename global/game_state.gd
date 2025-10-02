extends Node

var env_changes: Array[String] = []
var items: Array[String] = []
var perma_dead_enemies: Array[String] = []
var dead_enemies: Array[String] = []
var dead_body: DeadBody

class DeadBody:
    var scene: String
    var position: Vector2
    var money: int

func store_dead_body(player: Player) -> void:
    var new_body = DeadBody.new()
    if player.last_safe_point:
        new_body.position = player.last_safe_point.global_position
    else:
        new_body.position = player.global_position
    new_body.scene = MetSys.get_current_room_name()
    new_body.money = player.money
    dead_body = new_body

func create_body() -> void:
    var dead_body_scene = load("res://items/dead_body.tscn")
    var new_body = dead_body_scene.instantiate()
    new_body.global_position = dead_body.position
    new_body.money = dead_body.money
    MetSys.get_current_room_instance().add_child(new_body)

func reset_enemies() -> void:
    dead_enemies = []

func enemy_is_dead(enemy: Node2D) -> bool:
    var unique_key: String = get_node_unique_key(enemy)
    return unique_key in perma_dead_enemies || unique_key in dead_enemies

func add_perma_dead_enemy(enemy: Node2D) -> void:
    perma_dead_enemies.append(get_node_unique_key(enemy))

func find_perma_dead_enemy(enemy: Node2D) -> int:
    return perma_dead_enemies.find(get_node_unique_key(enemy))

func add_dead_enemy(enemy: Node2D) -> void:
    dead_enemies.append(get_node_unique_key(enemy))

func get_node_unique_key(enemy: Node2D) -> String:
    return enemy.get_parent().scene_file_path + str(enemy.get_path())

func is_item_collected(node: Node2D) -> bool:
    var unique_key: String = get_node_unique_key(node)
    return unique_key in items

func item_collected(node: Node2D) -> void:
    var unique_key: String = get_node_unique_key(node)
    items.append(unique_key)

func env_changed(node: Node2D) -> void:
    var unique_key: String = get_node_unique_key(node)
    env_changes.append(unique_key)

func env_is_changed(node) -> bool:
    if node is String:
        return node in env_changes

    var unique_key: String = get_node_unique_key(node)
    return unique_key in env_changes