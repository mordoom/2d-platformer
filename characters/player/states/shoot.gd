extends CharacterState

@onready var bullet_effect = preload("res://effects/bullet_effect.tscn")

@export var bullet_hitbox: Hitbox

var shoot_sound = preload("res://assets/sounds/warfare_gunshot.mp3")

func _ready() -> void:
    set_guard(shooting_allowed_check)

func shooting_allowed_check() -> bool:
    return owner.ammo > 0

func _enter() -> void:
    super._enter()
    SoundManager.play_sound_with_pitch(shoot_sound, Rng.generate_random_pitch(1, 1.5))
    owner.ammo -= 1

    var bullet_path: RayCast2D = owner.bullet_path
    if bullet_path.is_colliding():
        var collider = bullet_path.get_collider()

        if collider is Enemy:
            var direction = (collider.global_position - owner.global_position).normalized()
            for component in collider.components:
                if component is Hurtbox:
                    component.on_hurtbox_hit(bullet_hitbox, direction)
                    return
        else:
            var new_effect = bullet_effect.instantiate()
            new_effect.global_position = bullet_path.get_collision_point()
            get_root().add_child(new_effect)
