extends Node

signal on_health_changed(node: Node, amount: int)
signal on_player_position_changed(position: Vector2)
signal game_over()
signal character_died(node: Node)