extends CanvasLayer

@onready var gameOverMessage: Label = $GameOverMessage
@onready var message: Label = $Message

func _ready():
    SignalBus.connect("game_over", on_game_over)
    SignalBus.connect("on_display_message", on_display_message)
    init()

func init():
    gameOverMessage.visible = false
    message.visible = false

func on_game_over():
    gameOverMessage.visible = true

func on_display_message(text: String):
    message.text = text
    message.visible = true

func _input(event: InputEvent) -> void:
    if event.is_action_released("interact") && message.visible:
        message.visible = false