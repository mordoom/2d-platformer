extends Node

class_name CharacterStateMachine

var states: Array[State]
var states_dict = {}

@export var current_state: State
@export var character: CharacterBody2D
@export var animation_tree: AnimationTree

func _ready() -> void:
	for child in get_children():
		if (child is State):
			states.append(child)
			states_dict[child.name.to_lower()] = child
			child.character = character
			child.playback = animation_tree["parameters/playback"]
			child.connect("on_change_state", _on_change_state)

	current_state.on_enter()

func can_move() -> bool:
	return current_state.can_move

func is_dead() -> bool:
	return current_state.dead

func _physics_process(delta: float) -> void:
	current_state.state_physics_process(delta)

func _input(event: InputEvent):
	if current_state.input_allowed:
		current_state.state_input(event)

func _process(delta: float) -> void:
	current_state.state_process(delta)

func change_state(new_state: State):
	current_state.on_exit()
	current_state = new_state
	current_state.on_enter()

func _on_change_state(new_state: State):
	change_state(new_state)
