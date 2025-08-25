extends State

class_name LadderState

@export var idle_state: State

var character_colliding_with_ladder = false

func on_enter():
    super.on_enter()
    character.is_on_ladder = true

func on_exit():
    character.is_on_ladder = false

func _input(_event):
    if (Input.is_action_just_pressed("up")):
        if (character_colliding_with_ladder && not character.is_on_ladder):
            emit_signal("interrupt_state", self)
    elif (Input.is_action_just_pressed("down")):
        if character_colliding_with_ladder && not character.is_on_ladder:
            emit_signal("interrupt_state", self)
    elif (Input.is_action_just_released("down")):
        if (character.is_on_ladder && character.is_raycast_on_floor()):
            next_state = idle_state

func _on_interact_area_entered(area: Area2D) -> void:
    if area.get_parent().is_in_group("Ladder"):
        character_colliding_with_ladder = true

func _on_interact_area_exited(area: Area2D) -> void:
    if area.get_parent().is_in_group("Ladder"):
        character_colliding_with_ladder = false
        next_state = idle_state
