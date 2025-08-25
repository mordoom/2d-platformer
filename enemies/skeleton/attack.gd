extends State

class_name AttackState


func on_enter():
    playback.travel("attack")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
    if (anim_name == "attack"):
        emit_change_state("pursue")
