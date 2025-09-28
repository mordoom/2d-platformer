extends HBoxContainer

@onready var label: Label = $Label

var player: CharacterBody2D

func init(_player: CharacterBody2D) -> void:
	player = _player

func _process(_delta: float) -> void:
	if player:
		label.text = str(player.ammo)
