extends State

class_name GroundAttackState

@export var ground_state: State
@export var combo_timeout: float = 0.1

var current_attack_combo = 1
var can_combo = false

func state_input(event: InputEvent):
	if event.is_action_pressed("attack") && can_combo:
		if current_attack_combo == 1:
			advance_combo("attack2")
		elif current_attack_combo == 2:
			advance_combo("attack3")

func advance_combo(animation_name: String):
	current_attack_combo = current_attack_combo + 1
	playback.travel(animation_name)
	can_combo = false

func on_enter():
	current_attack_combo = 1
	can_combo = false
	playback.travel("attack")

func on_exit():
	current_attack_combo = 1
	can_combo = false
	super.on_exit()

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		can_combo = true
		await get_tree().create_timer(combo_timeout).timeout
		if current_attack_combo == 1:
			end_combo()

	elif anim_name == "attack2":
		can_combo = true
		await get_tree().create_timer(combo_timeout).timeout
		if current_attack_combo == 2:
			end_combo()
	elif anim_name == "attack3":
		end_combo()

func end_combo():
	playback.travel("Move")
	next_state = ground_state
