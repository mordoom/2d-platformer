extends Node

var dead_enemies: Array[String] = []

func enemy_is_dead(unique_key: String):
    return unique_key in dead_enemies