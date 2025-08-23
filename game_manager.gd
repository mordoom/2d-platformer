extends Node

var player
var player_position

func _ready() -> void:
    init()
    SignalBus.connect("on_player_position_changed", player_position_update)

func init():
    player = get_tree().get_first_node_in_group("Player")

func reload() -> void:
    get_tree().reload_current_scene()
    init()

func player_position_update(position: Vector2):
    player_position = position