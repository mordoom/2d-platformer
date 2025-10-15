class_name RiposteBox
extends Area2D

@export var posture_component: PostureComponent

func _ready() -> void:
    monitoring = false
    posture_component.connect("posture_break", _on_posture_break)
    connect("body_entered", _on_body_entered)
    connect("body_exited", _on_body_exited)

func _on_posture_break() -> void:
    monitoring = true

func on_posture_break_finish() -> void:
    monitoring = false

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        body.in_riposte_distance()

func _on_body_exited(body: Node2D) -> void:
    if body is Player:
        body.out_riposte_distance()

func die() -> void:
    on_posture_break_finish()

func flip(current_direction: float) -> void:
    if current_direction < 0:
        scale.x = -1
    elif current_direction > 0:
        scale.x = 1
