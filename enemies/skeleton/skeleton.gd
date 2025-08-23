extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var state_machine = $CharacterStateMachine
@onready var sprite = $Sprite2D
@onready var sword_collision = $AttackArea/CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
    animation_tree.active = true

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta

    var direction = get_direction()
    update_facing_direction(direction)
    update_animation(direction)
    if (state_machine.can_move()):
        move_and_slide()

func get_direction():
    return sign(velocity.x)

func update_animation(direction: float):
    animation_tree.set("parameters/patrol/blend_position", direction)

func update_facing_direction(direction: float):
    if direction < 0:
        sprite.flip_h = true
        if sign(sword_collision.position.x) == 1:
            sword_collision.position.x *= -1
    elif direction > 0:
        sprite.flip_h = false
        if sign(sword_collision.position.x) == -1:
            sword_collision.position.x *= -1
