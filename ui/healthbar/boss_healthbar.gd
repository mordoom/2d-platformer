class_name BossHealthbar
extends CanvasLayer

@export var hurtbox: Hurtbox
@export var health_component: HealthComponent
@export var boss_name: String

@onready var healthbar: ProgressBar = $Healthbar
@onready var label: Label = $Label
@onready var healthbar_timer: Timer = $HealthbarTimer

func _ready() -> void:
    label.text = boss_name
    visible = false
    healthbar.init_health(health_component.health)
    healthbar_timer.timeout.connect(show_healthbar)
    hurtbox.connect("on_hit", on_hit)
    health_component.connect("dead", dead)

func init_health(new_health: int) -> void:
    healthbar.init_health(new_health)

func on_hit(damage: int, _knockback_velocity: float, _direction: Vector2, stun: bool) -> void:
    healthbar.health = health_component.health

func dead() -> void:
    if healthbar_timer.is_stopped() && visible:
        healthbar_timer.start()
        healthbar_timer.timeout.connect(hide_healthbar)

func show_healthbar() -> void:
    visible = true

func hide_healthbar() -> void:
    visible = false
