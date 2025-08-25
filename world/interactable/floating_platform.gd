extends Node2D

@onready var start_pos = self.position
@export var offset_pos: Vector2
@export var duration: float = 2
@export var pause_duration: float = 1

func _ready():
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(self, "position", start_pos + offset_pos, duration)
	tween.tween_interval(pause_duration)
	tween.tween_property(self, "position", start_pos, duration)
	tween.tween_interval(pause_duration)
	tween.set_loops()
