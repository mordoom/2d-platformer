extends Node

class_name CharacterStateMachine

var states: Array[State]
@export var current_state: State
@export var player: CharacterBody2D
@export var animation_tree: AnimationTree

signal interrupt_state(new_state: State)

func _ready() -> void:
	for child in get_children():
		if (child is State):
			states.append(child)
			child.player = player
			child.playback = animation_tree["parameters/playback"]
			child.connect("interrupt_state", on_interrupt_state)

func can_move() -> bool:
	return current_state.can_move

func _physics_process(delta: float) -> void:
	if (current_state.next_state != null):
		change_state(current_state.next_state)

func _input(event: InputEvent):
	current_state.state_input(event)

func _process(delta: float) -> void:
	current_state.state_process(delta)

func change_state(new_state: State):
	current_state.on_exit()
	current_state = new_state
	current_state.on_enter()

func on_interrupt_state(new_state: State):
	change_state(new_state)
