extends State

class_name LadderState

var on_ladder = false

func on_enter():
    super.on_enter()
    character.climbing = true

func on_exit():
    super.on_exit()
    character.climbing = false
    on_ladder = false

func state_input(event):
    if event.is_action_pressed("jump"):
        emit_signal("on_change_state", "jump")

func _input(_event):
    if (Input.is_action_just_pressed("up")):
        if (on_ladder && not character.climbing):
            emit_signal("on_change_state", "ladder")
    elif (Input.is_action_just_pressed("down")):
        if on_ladder && not character.climbing:
            emit_signal("on_change_state", "ladder")
    elif (Input.is_action_just_released("down")):
        if (character.climbing && character.is_raycast_on_floor()):
            emit_signal("on_change_state", "ground")

func _on_interact_area_entered(area: Area2D) -> void:
    if area.get_parent().is_in_group("Ladder"):
        on_ladder = true

func _on_interact_area_exited(area: Area2D) -> void:
    if area.get_parent().is_in_group("Ladder"):
        emit_signal("on_change_state", "ground")
