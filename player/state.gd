extends Node

class_name State

@export var can_move = true
@export var input_allowed = true
@export var dead = false
@export var character: CharacterBody2D

signal on_change_state(new_state: State)
signal reset_state()

var playback: AnimationNodeStateMachinePlayback

func state_input(_event):
	pass

func state_process(_delta):
	pass

func state_physics_process(_delta):
	pass

func emit_change_state(new_state):
	emit_signal("on_change_state", new_state)

func emit_reset_state():
	emit_signal("reset_state")

func on_enter():
	pass
	
func on_exit():
	pass
