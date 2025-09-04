extends ProgressBar

@onready var damage_bar: ProgressBar = $Damagebar
@onready var timer: Timer = $Timer

var health: int = 0: set = set_health

func set_health(new_health: int) -> void:
    var prev_health: int = health
    health = min(max_value, new_health)
    value = health
    if (new_health < 0):
        value = 0
    
    if health < prev_health:
        timer.start()
    else:
        damage_bar.value = health
    
    
func init_health(new_health: int) -> void:
    health = new_health
    max_value = new_health
    value = health
    damage_bar.max_value = health
    damage_bar.value = health


func _on_timer_timeout() -> void:
    damage_bar.value = health