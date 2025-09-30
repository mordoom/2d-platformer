extends CharacterState

@export var stop_movement = true

var sword_swing_sound = preload("res://assets/sounds/zapsplat_sword_swing.mp3")

var combo_count := 1
var default_max_combo = 2
var idle_max_combo = 3
var advance_combo := false
var combo_cooldown_time := 0.15
var combo_cooldown_timer := 0.0

func _enter() -> void:
    super._enter()
    combo_count = 1
    advance_combo = false
    combo_cooldown_timer = combo_cooldown_time

    SoundManager.play_sound_with_pitch(sword_swing_sound, Rng.generate_random_pitch())

    if stop_movement:
        blackboard.set_var(GameConstants.BlackboardVars.current_speed_var, 0)

func _update(delta: float) -> void:
    combo_cooldown_timer -= delta

    var max_combo = default_max_combo
    if hsm.get_previous_active_state().name == "Idle":
        max_combo = idle_max_combo

    var action_pressed = blackboard.get_var(GameConstants.BlackboardVars.action_pressed_var)
    if advance_combo == false && combo_cooldown_timer <= 0 && action_pressed == &"attack":
        advance_combo = true
        combo_count += 1

    if not animation_player.is_playing():
        if advance_combo && combo_count <= max_combo:
            advance_combo = false
            combo_cooldown_timer = combo_cooldown_time
            SoundManager.play_sound_with_pitch(sword_swing_sound, Rng.generate_random_pitch())
            animation_player.play(animation_name + str(combo_count))
        else:
            hsm.dispatch(EVENT_FINISHED)
    else:
        if blackboard.get_var(GameConstants.BlackboardVars.dir_var).x == 0 && animation_name == "RunAttack":
            var current_pos = animation_player.current_animation_position
            animation_player.play("Attack")
            animation_player.seek(current_pos)
        if owner.is_on_floor() && animation_name == "JumpAttack":
            var current_pos = animation_player.current_animation_position
            animation_player.play("Attack")
            animation_player.seek(current_pos)
