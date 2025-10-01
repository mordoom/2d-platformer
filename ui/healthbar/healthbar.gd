extends ProgressBar

@onready var damage_bar: ProgressBar = $Damagebar
@onready var damage_indication_timer: Timer = $Timer
@onready var low_health_timer: Timer = $Timer2

var low_health_percentage := 0.5
var health: int = 0: set = set_health

func set_health(new_health: int) -> void:
    var prev_health: int = health
    health = min(max_value, new_health)
    value = health
    if new_health < 0:
        value = 0
    
    if health < prev_health:
        damage_indication_timer.start()
    else:
        damage_bar.value = health
    
    if health / max_value <= low_health_percentage:
        low_health_timer.start()
    else:
        low_health_timer.stop()
        visible = true

    
func init_health(new_health: int) -> void:
    max_value = new_health
    health = new_health
    value = health
    damage_bar.max_value = health
    damage_bar.value = health


func _on_timer_timeout() -> void:
    damage_bar.value = health

func _on_timer_2_timeout() -> void:
    visible = !visible
