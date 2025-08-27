extends Node

signal on_health_changed(node: Node, amount: int)
signal game_over()
signal character_died(node: Node)
signal on_campfire_rested(area: Area2D)
signal on_display_message(text: String)
