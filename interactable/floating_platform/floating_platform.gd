extends Node2D

@onready var start_pos: Vector2 = self.global_position
@export var offset_pos: Vector2
@export var duration: float = 2
@export var pause_duration: float = 1
@export var enabled := true

@onready var animatablebody: AnimatableBody2D = $AnimatableBody2D

func _ready() -> void:
    if enabled:
        begin_moving()

func begin_moving() -> void:
    var tween: Tween = get_tree().create_tween().bind_node(self)
    tween.tween_property(animatablebody, "global_position", start_pos + offset_pos, duration)
    tween.tween_interval(pause_duration)
    tween.tween_property(animatablebody, "global_position", start_pos, duration)
    tween.tween_interval(pause_duration)
    tween.set_loops().set_parallel(false)
