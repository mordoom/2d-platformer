class_name SwingRope
extends Area2D

@onready var rope: Line2D = $Line2D
@onready var marker: Marker2D = $Marker2D

@export var min_rotation := -70.0
@export var max_rotation := 75.0
@export var rotation_speed := 200

var current_direction := -1.0

func _physics_process(delta: float) -> void:
    if rotation_degrees <= min_rotation:
        current_direction = 1.0
    elif rotation_degrees >= max_rotation:
        current_direction = -1.0
    
    rotation_degrees += current_direction * rotation_speed * delta