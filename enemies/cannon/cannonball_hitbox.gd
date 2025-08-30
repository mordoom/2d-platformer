extends DamageArea

func custom_damage_behaviour():
    # TODO: generate an explosion effect
    get_parent().queue_free()
