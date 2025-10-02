extends Node2D
class_name EnableComponent

@export var enabler: Node2D
@export var enabler_string: String

func _ready():
	if enabler_string:
		if GameState.env_is_changed(enabler_string):
			toggle_child()
		else:
			SignalBus.connect("on_env_change", _on_enable)
	else:
		if GameState.env_is_changed(enabler):
			toggle_child()
		else:
			SignalBus.connect("on_env_change", _on_enable)

	var child = get_child(0)
	if child is Area2D:
		child.monitoring = child.visible
		child.monitorable = child.visible

func _on_enable(node: Node2D) -> void:
	if node == enabler:
		toggle_child()
	
func toggle_child() -> void:
	var child = get_child(0)
	child.visible = !child.visible
	if child is Area2D:
		child.monitoring = child.visible
		child.monitorable = child.visible
