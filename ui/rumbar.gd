extends HBoxContainer

@onready var label = $Label

var player

func init(_player):
    player = _player

func _process(_delta):
    if player:
        label.text = str(player.rum_bottles)