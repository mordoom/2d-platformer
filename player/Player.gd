extends CharacterBody2D

@export var speed: float = GameConstants.PLAYER_SPEED
var current_speed = speed

@export var ladder_speed = GameConstants.LADDER_SPEED
var is_on_ladder = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine = $CharacterStateMachine
@onready var sword_collision = $Sword/CollisionShape2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var death_time: float = GameConstants.DEATH_TIME
var death_timer = null

func _ready():
    animation_tree.active = true

func _physics_process(delta):
    if state_machine.is_dead():
        return

    if not is_on_floor() && not is_on_ladder:
        velocity.y += gravity * delta

    if is_on_ladder:
        var upward_direction = get_vertical_direction()
        velocity.y = upward_direction * ladder_speed

    var direction = get_horizontal_direction()
    if direction && state_machine.can_move():
        velocity.x = direction * current_speed
    else:
        velocity.x = move_toward(velocity.x, 0, current_speed)

    move_and_slide()
    SignalBus.emit_signal("on_player_position_changed", position)

func get_vertical_direction():
    return Input.get_axis("up", "down")

func get_horizontal_direction():
    return Input.get_axis("left", "right")

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
