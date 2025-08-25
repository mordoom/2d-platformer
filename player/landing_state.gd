extends State

class_name LandingState

var landing_dust_anim = preload("res://effects/landing_dust_anim.tscn")
@export var ground_state: State

func on_enter():
	var landing_dust = landing_dust_anim.instantiate()
	get_tree().get_root().add_child(landing_dust)
	landing_dust.global_position = character.global_position

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "landing"):
		emit_signal("on_change_state", "ground")
