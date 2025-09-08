extends State

class_name GroundState

var start_cooldown_timer: float = 0.01
var cooldown_timer: float = start_cooldown_timer

func on_enter() -> void:
    playback.travel("move")

func state_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("jump") || InputBuffer.is_action_press_buffered("jump"):
        emit_change_state("jump")
    elif Input.is_action_just_pressed("attack") && cooldown_timer <= 0:
        cooldown_timer = start_cooldown_timer
        emit_change_state("groundattack")
        
func state_physics_process(delta: float) -> void:
    cooldown_timer -= delta
    if not character.is_on_floor():
        emit_change_state("air")
