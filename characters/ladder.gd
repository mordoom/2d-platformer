extends State

class_name LadderState

@export var idle_state: State
@export var air_state: State

var on_ladder = false

func on_enter():
    super.on_enter()
    character.climbing = true

func on_exit():
    super.on_exit()
    character.climbing = false

func state_input(event):
    if event.is_action_pressed("jump"):
        idle_state.jump()
        emit_signal("on_change_state", air_state)

func _input(_event):
    if (Input.is_action_just_pressed("up")):
        if (on_ladder && not character.climbing):
            emit_signal("on_change_state", self)
    elif (Input.is_action_just_pressed("down")):
        if on_ladder && not character.climbing:
            emit_signal("on_change_state", self)
    elif (Input.is_action_just_released("down")):
        if (character.climbing && character.is_raycast_on_floor()):
            emit_signal("on_change_state", idle_state)

func _on_interact_area_entered(area: Area2D) -> void:
    if area.get_parent().is_in_group("Ladder"):
        on_ladder = true

func _on_interact_area_exited(area: Area2D) -> void:
    if area.get_parent().is_in_group("Ladder"):
        on_ladder = false
        emit_signal("on_change_state", idle_state)
