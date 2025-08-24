extends Node

var player: Node
var player_position
var death_timer

func _ready() -> void:
	init()
	SignalBus.connect("on_player_position_changed", player_position_update)
	SignalBus.connect("character_died", on_character_died_handler)

func init():
	player = get_tree().get_first_node_in_group("Player")

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
	get_tree().reload_current_scene()
	init()

func player_position_update(position: Vector2):
	player_position = position
