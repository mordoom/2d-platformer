extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = $CharacterStateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
    animation_tree.active = true

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta