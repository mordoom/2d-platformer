extends CanvasLayer

@export var heal_sound: AudioStream

@onready var healMessage: VBoxContainer = $HealContainer
@onready var healMessageTimer: Timer = $HealContainer/Timer
@onready var gameOverMessage: VBoxContainer = $GameOverContainer
@onready var message: Label = $Message
@onready var healthbar: ProgressBar = $Healthbar
@onready var rumbar: HBoxContainer = $Rumbar
@onready var ammo_display: HBoxContainer = $AmmoDisplay
@onready var player: Player = %Player
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
	SignalBus.connect("on_campfire_rested", _on_campfire_rested)

func init() -> void:
	healMessage.visible = false
	healMessageTimer.timeout.connect(_hide_heal_message)
	gameOverMessage.visible = false
	message.visible = false
	healthbar.init_health(player.get_health())
	rumbar.init(player)
	ammo_display.init(player)
	money = player.money
	target_money = money

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

func _on_money_collected(_area: Area2D, amount: int):
	target_money += amount
	var tween := get_tree().create_tween()
	tween.tween_property(self, "money", target_money, 1.0)

func _on_campfire_rested(_area: Area2D) -> void:
	healMessage.visible = true
	healMessageTimer.start()
	SoundManager.play_sound(heal_sound)

func _hide_heal_message() -> void:
	healMessage.visible = false