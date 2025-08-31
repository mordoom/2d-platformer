extends Node

var player_scene = preload("res://player/Player.tscn")
var initial_level = preload("res://world/cave/levels/starting_area.tscn")
var jump_dust_anim = preload("res://effects/jump_dust_anim.tscn")
var landing_dust_anim = preload("res://effects/landing_dust_anim.tscn")
var skeleton_scene = preload("res://enemies/skeleton/skeleton.tscn")
var health_changed_label = preload("res://ui/damage_label.tscn")

func instantiate(scene: PackedScene, global_position: Vector2):
    var new_thing = scene.instantiate()
    get_tree().get_root().add_child(new_thing)
    new_thing.global_position = global_position
    return new_thing

func instantiate_deferred(scene: PackedScene, global_position: Vector2, parent: Node2D):
    var new_thing = scene.instantiate()
    parent.add_child.call_deferred(new_thing)
    new_thing.global_position = global_position
    return new_thing