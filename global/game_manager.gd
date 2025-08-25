extends Node

class_name GameManager

var player: Node
var player_scene = preload("res://player/Player.tscn")
var player_position: Vector2
var camera: Camera2D

var death_timer: Timer
var initial_level = preload("res://world/cave/levels/starting_area.tscn")
var current_level: Node
var current_level_bounds: Rect2i

const cell_size = 16
const starting_offset = 2 * cell_size

func _ready() -> void:
	init()
	SignalBus.connect("on_player_position_changed", player_position_update)
	SignalBus.connect("character_died", on_character_died_handler)

func init():
	if (player):
		player.queue_free()

	player = player_scene.instantiate()
	camera = player.get_node("Camera2D")
	player.global_position = GameConstants.PLAYER_INITIAL_POSITION
	add_child.call_deferred(player)
	init_level(initial_level)

func init_level(level: PackedScene):
	var new_level = load_level(level)
	current_level = new_level
	current_level_bounds = get_current_level_bounds()

	camera.limit_left = current_level_bounds.position.x
	camera.limit_right = current_level_bounds.size.x
	camera.limit_bottom = current_level_bounds.size.y
	camera.limit_top = current_level_bounds.position.y

func load_level(level: PackedScene):
	if (current_level != null):
		current_level.queue_free()
	var new_level = level.instantiate()
	add_child.call_deferred(new_level)
	return new_level


func on_character_died_handler(character: Node):
	if character.is_in_group("Player"):
		SignalBus.emit_signal("game_over")
		start_death_timer()

func start_death_timer():
	death_timer = Timer.new()
	death_timer.wait_time = GameConstants.DEATH_TIME
	death_timer.one_shot = true
	death_timer.timeout.connect(reload)
	add_child(death_timer)
	death_timer.start()

func reload() -> void:
	init()

func player_position_update(position: Vector2):
	player_position = position
	check_level_bounds()

func check_level_bounds():
	if (player_position.x >= current_level_bounds.size.x):
		check_and_load_next_level(current_level.right_level, Vector2.RIGHT)
	elif (player_position.x <= current_level_bounds.position.x):
		check_and_load_next_level(current_level.left_level, Vector2.LEFT)
	elif (player_position.y <= current_level_bounds.position.y):
		check_and_load_next_level(current_level.up_level, Vector2.UP)
	elif (player_position.y >= current_level_bounds.size.y):
		check_and_load_next_level(current_level.down_level, Vector2.DOWN)

func check_and_load_next_level(level_path, entry_direction: Vector2):
	if level_path == "":
		reload()
		print_debug("no connecting level found - game over")
	else:
		init_level(load(level_path))
		player.position = get_next_starting_pos(entry_direction)

func get_next_starting_pos(entry_direction: Vector2):
	if (entry_direction == Vector2.RIGHT):
		var left_position = current_level_bounds.position.x + starting_offset
		return Vector2(left_position, player_position.y)
	elif entry_direction == Vector2.LEFT:
		var right_position = current_level_bounds.size.x - starting_offset
		return Vector2(right_position, player_position.y)
	elif entry_direction == Vector2.UP:
		var bottom_position = current_level_bounds.size.y - starting_offset
		return Vector2(player_position.x, bottom_position)
	elif entry_direction == Vector2.DOWN:
		var top_position = current_level_bounds.position.y + starting_offset
		return Vector2(player_position.x, top_position)


func get_current_level_bounds():
	var tilemap_node = current_level.get_node("TileMapLayer")
	var used_rect = tilemap_node.get_used_rect()
	var top_left_local = tilemap_node.map_to_local(used_rect.position)
	var bottom_right_local = tilemap_node.map_to_local(used_rect.end)
	var level_bounds = Rect2i(top_left_local, bottom_right_local)
	return level_bounds
