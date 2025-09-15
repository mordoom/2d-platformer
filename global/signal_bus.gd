extends Node

signal on_health_changed(node: Node, amount: int)
signal game_over()
signal character_died(node: Node)

signal rum_consumed()
signal on_bottle_rum_collected(area: Area2D)
signal on_campfire_rested(area: Area2D)
signal money_collected(amount: int)

signal on_display_message(text: String)
signal on_remove_message()