extends Node

class_name State

@export var can_move: bool = true
@export var input_allowed: bool = true
@export var dead: bool = false
@export var character: CharacterBody2D

signal on_change_state(new_state: State)
signal reset_state()

var playback: AnimationNodeStateMachinePlayback

func state_input(_event: InputEvent) -> void:
	pass

func state_process(_delta: float) -> void:
	pass

func state_physics_process(_delta: float) -> void:
	pass

func emit_change_state(new_state: String) -> void:
	emit_signal("on_change_state", new_state)

func emit_reset_state() -> void:
	emit_signal("reset_state")

func change_state_after_animation(does_anim_name_match: bool, new_state: String) -> void:
	if (does_anim_name_match && get_parent().current_state == self):
		emit_change_state(new_state)

func on_enter() -> void:
	pass
	
func on_exit() -> void:
	pass
