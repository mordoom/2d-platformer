extends CharacterBody2D

@export var speed: float = GameConstants.PLAYER_SPEED
var current_speed = speed

@export var ladder_speed = GameConstants.LADDER_SPEED
var climbing = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine = $CharacterStateMachine
@onready var sword_collision = $Sword/CollisionShape2D

@onready var floor_check: RayCast2D = $floor_check

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
    animation_tree.active = true

func reset():
    pass

func _physics_process(delta):
    if state_machine.is_dead():
        return

    if not is_on_floor() && not climbing:
        velocity.y += gravity * delta

    if climbing:
        var upward_direction = get_vertical_direction()
        if upward_direction:
            velocity.y = upward_direction * ladder_speed
        else:
            velocity.y = move_toward(velocity.y, 0, ladder_speed)
    else:
        var direction = get_horizontal_direction()
        if direction && state_machine.can_move():
            velocity.x = direction * current_speed
        else:
            velocity.x = move_toward(velocity.x, 0, current_speed)

    move_and_slide()
    SignalBus.emit_signal("on_player_position_changed", position)

func _input(_event: InputEvent) -> void:
    if state_machine.current_state.input_allowed:
        var direction = get_horizontal_direction()
        update_animation(direction)
        update_facing_direction(direction)

func update_animation(direction: float = 0):
    animation_tree.set("parameters/move/blend_position", direction)

func update_facing_direction(direction: float):
    if direction < 0:
        sprite.flip_h = true
        if sign(sword_collision.position.x) == 1:
            sword_collision.position.x *= -1
    elif direction > 0:
        sprite.flip_h = false
        if sign(sword_collision.position.x) == -1:
            sword_collision.position.x *= -1

func is_raycast_on_floor():
    return floor_check.is_colliding()

func get_vertical_direction():
    return Input.get_axis("up", "down")

func get_horizontal_direction():
    return Input.get_axis("left", "right")
