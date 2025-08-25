extends State

class_name JumpState

@export var jump_velocity = GameConstants.JUMP_VELOCITY

func on_enter():
    jump()

func state_physics_process(_delta):
    if character.is_on_floor():
        emit_change_state("landing")
    elif character.velocity.y > 0:
        playback.travel("falling")

func jump():
    character.velocity.y = jump_velocity
    create_jump_dust()
    playback.travel("jump")

func create_jump_dust():
    References.instantiate(References.jump_dust_anim, character.global_position)
