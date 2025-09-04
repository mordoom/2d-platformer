extends State

class_name LandingState

var landing_dust_anim: PackedScene = References.landing_dust_anim

func on_enter() -> void:
	playback.travel("landing")
	create_landing_dust()

func state_input(_event: InputEvent) -> void:
	if InputBuffer.is_action_press_buffered("jump"):
		emit_change_state("jump")

func create_landing_dust() -> void:
	References.instantiate(landing_dust_anim, character.global_position)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	change_state_after_animation(anim_name == "landing", "ground")
