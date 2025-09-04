extends State

class_name AttackState

func on_enter() -> void:
    playback.travel("attack")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
    change_state_after_animation(anim_name == "attack", "pursue")
