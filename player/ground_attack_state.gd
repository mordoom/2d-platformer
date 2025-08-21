extends State

class_name GroundAttackState

@export var ground_state: State

func state_input(event: InputEvent):
	pass

func state_process(delta):
	pass

func on_enter():
	playback.travel("attack")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "attack"):
		playback.travel("Move")
		next_state = ground_state
