extends BTAction

@export var max_patrol_distance: Vector2

func _tick(delta: float) -> Status:
    var starting_point = blackboard.get_var(&"starting_point")

    var x = Rng.rng.randi_range(-max_patrol_distance.x, max_patrol_distance.x)
    var y = Rng.rng.randi_range(-max_patrol_distance.y, max_patrol_distance.y)

    var position_difference := Vector2(x, y)
    var patrol_point: Vector2 = position_difference + starting_point
    
    blackboard.set_var(&"patrol_point", patrol_point)

    return SUCCESS
