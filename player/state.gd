extends Node

class_name State

@export var can_move = true
@export var player: CharacterBody2D

var next_state: State
var playback: AnimationNodeStateMachinePlayback

func state_input(event):
	pass

func state_process(delta):
	pass

func on_enter():
	pass
	
func on_exit():
	if (next_state):
		next_state = null
