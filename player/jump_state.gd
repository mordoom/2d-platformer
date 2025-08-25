extends State

class_name JumpState

@export var landing_state: State
@export var jump_velocity = GameConstants.JUMP_VELOCITY
var jump_dust_anim = preload("res://effects/jump_dust_anim.tscn")

func on_enter():
    jump()

func state_physics_process(_delta):
    if character.is_on_floor():
        playback.travel("landing")
        emit_signal("on_change_state", "landing")
    elif character.velocity.y > 0:
            playback.travel("falling")

func jump():
    character.velocity.y = jump_velocity
    create_jump_dust()
    playback.travel("jump")

func create_jump_dust():
    var jump_dust = jump_dust_anim.instantiate()
    get_tree().get_root().add_child(jump_dust)
    jump_dust.global_position = character.global_position