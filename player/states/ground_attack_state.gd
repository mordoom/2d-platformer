extends State

class_name GroundAttackState

@onready var timer: Timer = $Timer

func on_enter() -> void:
	playback.travel("attack")

func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		timer.start()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		if timer.is_stopped():
			end_combo()
		else:
			timer.stop()
			playback.travel("attack2")
	elif anim_name == "attack2":
		if timer.is_stopped():
			end_combo()
		else:
			timer.stop()
			playback.travel("attack3")
	elif anim_name == "attack3":
		end_combo()

func end_combo() -> void:
	emit_change_state("ground")
