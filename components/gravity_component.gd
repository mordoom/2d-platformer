class_name GravityComponent
extends Node

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var character: CharacterBody2D = get_parent()

func add_gravity(delta):
    if not character.is_on_floor():
        character.velocity.y += gravity * delta