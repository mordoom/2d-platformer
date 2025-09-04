extends Node

var player_scene: PackedScene = preload("res://player/Player.tscn")
var initial_level: PackedScene = preload("res://world/cave/levels/starting_area.tscn")
var jump_dust_anim: PackedScene = preload("res://effects/jump_dust_anim.tscn")
var landing_dust_anim: PackedScene = preload("res://effects/landing_dust_anim.tscn")
var skeleton_scene: PackedScene = preload("res://enemies/skeleton/skeleton.tscn")
var health_changed_label: PackedScene = preload("res://ui/damage_counter/damage_label.tscn")

func instantiate(scene: PackedScene, global_position: Vector2) -> Node:
	var new_thing: Node = scene.instantiate()
	get_tree().get_root().add_child(new_thing)
	new_thing.global_position = global_position
	return new_thing

func instantiate_deferred(scene: PackedScene, parent: Node2D, position: Vector2) -> Node:
	var new_thing: Node = scene.instantiate()
	new_thing.position = position
	parent.add_child.call_deferred(new_thing)
	return new_thing
