extends State

class_name LandingState

@export var ground_state: State

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "landing"):
		next_state = ground_state
