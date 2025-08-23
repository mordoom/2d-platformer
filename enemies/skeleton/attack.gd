extends State

class_name AttackState

@export var pursue_state: State

func on_enter():
    playback.travel("attack")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
    if (anim_name == "attack"):
        next_state = pursue_state
