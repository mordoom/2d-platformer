extends CollectionComponent

func _ready() -> void:
    pass

func collect() -> void:
    SignalBus.emit_signal("money_collected", owner, owner.money)
    GameState.dead_body = null
    get_parent().queue_free()