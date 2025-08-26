extends Node

var player_scene = preload("res://player/Player.tscn")
var initial_level = preload("res://world/cave/levels/room_with_enemies.tscn")
var jump_dust_anim = preload("res://effects/jump_dust_anim.tscn")
var landing_dust_anim = preload("res://effects/landing_dust_anim.tscn")
var skeleton_scene = preload("res://enemies/skeleton/skeleton.tscn")
var health_changed_label = preload("res://ui/damage_label.tscn")

func instantiate(scene: PackedScene, global_position: Vector2):
    var new_thing = scene.instantiate()
    get_tree().get_root().add_child(new_thing)
    new_thing.global_position = global_position