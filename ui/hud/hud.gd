extends CanvasLayer

@onready var gameOverMessage: Label = $GameOverMessage
@onready var message: Label = $Message
@onready var healthbar: ProgressBar = $Healthbar
@onready var rumbar: HBoxContainer = $Rumbar
@onready var player: CharacterBody2D = %Player
@onready var money_label: Label = $MoneyDisplay

var target_money := 0
var money := 0:
	set(new_money):
		money = new_money
		update_money_label()

func _ready() -> void:
	SignalBus.connect("game_over", on_game_over)
	SignalBus.connect("on_display_message", on_display_message)
	SignalBus.connect("on_remove_message", on_remove_message)
	SignalBus.connect("on_health_changed", on_health_changed)
	SignalBus.connect("money_collected", _on_money_collected)

func init() -> void:
	gameOverMessage.visible = false
	message.visible = false
	healthbar.init_health(player.get_health())
	rumbar.init(player)
	money = player.money
	update_money_label()

func on_game_over() -> void:
	gameOverMessage.visible = true

func on_display_message(text: String) -> void:
	message.text = text
	message.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_released("interact") && message.visible:
		message.visible = false

func on_remove_message() -> void:
	message.visible = false

func on_health_changed(node: Node, amount: int) -> void:
	if node.is_in_group("Player"):
		var new_health: int = healthbar.health + amount
		healthbar.health = new_health

func update_money_label() -> void:
	money_label.text = "$" + str(money)

func _on_money_collected(amount: int):
	target_money += amount
	var tween := get_tree().create_tween()
	tween.tween_property(self, "money", target_money, 1.0)
