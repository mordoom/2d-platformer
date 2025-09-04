extends DamageArea

func custom_damage_behaviour() -> void:
    # TODO: generate an explosion effect
    get_parent().reset()
