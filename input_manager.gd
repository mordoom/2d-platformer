class_name InputManager
extends Node

@export var hsm: LimboHSM

func _input(_event):
    var dir: Vector2 = Input.get_vector(&"left", &"right", &"up", &"down")
    hsm.blackboard.set_var(GameConstants.BlackboardVars.dir_var, dir)

    var action_pressed: StringName = &"none"
    
    if Input.is_action_just_pressed("drink_rum"):
        action_pressed = &"drink_rum"
    elif Input.is_action_pressed(&"interact"):
        owner.handle_interactions()
    elif Input.is_action_just_pressed(&"roll"):
        action_pressed = &"roll"
    elif Input.is_action_just_pressed(&"shoot"):
        action_pressed = &"shoot"
    elif Input.is_action_just_pressed(&"jump"):
        action_pressed = &"jump"
    elif Input.is_action_just_pressed(&"attack"):
        action_pressed = &"attack"
    elif Input.is_action_just_pressed(&"deflect"):
        action_pressed = &"deflect"

    hsm.blackboard.set_var(GameConstants.BlackboardVars.action_pressed_var, action_pressed)

func get_horizontal_direction() -> float:
    return Input.get_axis("left", "right")