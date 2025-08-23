extends Node

class_name State

@export var can_move = true
@export var character: CharacterBody2D

var next_state: State
var playback: AnimationNodeStateMachinePlayback

signal interrupt_state(new_state: State)

func state_input(_event):
	pass

func state_process(_delta):
	pass

func state_physics_process(_delta):
	pass

func on_enter():
	pass
	
func on_exit():
	if (next_state):
		next_state = null
