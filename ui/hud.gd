extends CanvasLayer

@onready var gameOverMessage: Label = $GameOverMessage

func _ready():
    SignalBus.connect("game_over", on_game_over)
    init()

func init():
    gameOverMessage.visible = false

func on_game_over():
    gameOverMessage.visible = true