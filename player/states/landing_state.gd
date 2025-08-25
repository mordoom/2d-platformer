extends State

class_name LandingState

var landing_dust_anim = preload("res://effects/landing_dust_anim.tscn")

func on_enter():
	playback.travel("landing")
	create_landing_dust()

func create_landing_dust():
	var landing_dust = landing_dust_anim.instantiate()
	get_tree().get_root().add_child(landing_dust)
	landing_dust.global_position = character.global_position

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "landing" && get_parent().current_state == self):
		emit_change_state("ground")
