class_name BossHealthbar
extends CanvasLayer

@export var state_machine: CharacterStateMachine
@export var boss_name: String
@export var damageable: Damageable

@onready var healthbar: ProgressBar = $Healthbar
@onready var label: Label = $Label
@onready var healthbar_timer: Timer = $HealthbarTimer

func _ready() -> void:
	label.text = boss_name
	visible = false
	healthbar.init_health(damageable.health)
	healthbar_timer.timeout.connect(show_hide_healthbar)
	damageable.connect("on_hit", on_damageable_hit)

func init_health(new_health: int) -> void:
	healthbar.init_health(new_health)

func on_damageable_hit(_node: Node, _damage_taken: int, _direction: Vector2) -> void:
	healthbar.health = damageable.health

func dead() -> void:
	if healthbar_timer.is_stopped() && visible:
		healthbar_timer.start()

func show_hide_healthbar() -> void:
	if state_machine.is_dead():
		visible = false
	else:
		visible = true
