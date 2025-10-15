class_name PostureComponent
extends Node

@export var starting_posture := 1
var posture

signal posture_break

func _ready():
    reset()

func was_deflected() -> void:
    posture -= 1
    if posture == 0:
        emit_signal("posture_break")
    
func reset() -> void:
    posture = starting_posture