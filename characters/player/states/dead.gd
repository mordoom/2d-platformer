extends CharacterState

func _enter() -> void:
    super._enter()
    owner.hitbox.monitoring = false
    SignalBus.emit_signal("character_died", owner)

func _update(_delta: float) -> void:
    owner.velocity.x = move_toward(owner.velocity.x, 0, owner.movement_speed)