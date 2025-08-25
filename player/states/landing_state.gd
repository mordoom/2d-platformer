extends State

class_name LandingState

var landing_dust_anim = References.landing_dust_anim

func on_enter():
	playback.travel("landing")
	create_landing_dust()

func create_landing_dust():
	References.instantiate(landing_dust_anim, character.global_position)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "landing" && get_parent().current_state == self):
		emit_change_state("ground")
