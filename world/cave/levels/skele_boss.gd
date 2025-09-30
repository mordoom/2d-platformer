extends Node2D

@onready var floating_platform: Node2D = $FloatingPlatform
@onready var dino: Enemy = $Dinoskele

func _ready() -> void:
	if GameState.find_perma_dead_enemy(dino) >= 0:
		floating_platform.begin_moving()

func _on_dinoskele_dead() -> void:
	floating_platform.begin_moving()
