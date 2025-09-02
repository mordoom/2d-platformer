extends CanvasLayer

@onready var gameOverMessage: Label = $GameOverMessage
@onready var message: Label = $Message
@onready var healthbar = $Healthbar
@onready var rumbar = $Rumbar
@onready var player = %Player

func _ready():
    SignalBus.connect("game_over", on_game_over)
    SignalBus.connect("on_display_message", on_display_message)
    SignalBus.connect("on_remove_message", on_remove_message)
    SignalBus.connect("on_health_changed", on_health_changed)

func init():
    gameOverMessage.visible = false
    message.visible = false
    healthbar.init_health(player.get_health())
    rumbar.init(player)

func on_game_over():
    gameOverMessage.visible = true

func on_display_message(text: String):
    message.text = text
    message.visible = true

func _input(event: InputEvent) -> void:
    if event.is_action_released("interact") && message.visible:
        message.visible = false

func on_remove_message():
    message.visible = false

func on_health_changed(node: Node, amount: int):
    if node.is_in_group("Player"):
        var new_health = healthbar.health + amount
        healthbar.health = new_health
