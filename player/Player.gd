extends CharacterBody2D

@export var speed: float = GameConstants.PLAYER_SPEED
var current_speed: float = speed
var player_gravity_multiplier: float = GameConstants.PLAYER_GRAVITY_MULT

@export var ladder_speed: float = GameConstants.LADDER_SPEED
var climbing: bool = false
var on_ladder: Area2D
var is_ladder_above: bool = false

var on_interactable: Area2D
var on_collectible: Area2D

var rum_bottles: int = 0
var max_rum_bottles: int = 0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var sword_collision: CollisionShape2D = $Sword/CollisionShape2D
@onready var floor_check: RayCast2D = $floor_check
@onready var ceiling_check: RayCast2D = $ceiling_check
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var damageable: Damageable = $Damageable
@onready var ladderAboveArea: Area2D = $LadderAbove

func _ready() -> void:
	animation_tree.active = true
	on_enter()

func on_enter() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor() && not climbing:
		velocity.y += gravity * player_gravity_multiplier * delta

	if state_machine.current_state.input_allowed:
		if climbing:
			var upward_direction: float = get_vertical_direction()
			if upward_direction:
				velocity.y = upward_direction * ladder_speed
			else:
				velocity.y = move_toward(velocity.y, 0, ladder_speed)

		var direction: float = get_horizontal_direction()
		if direction && state_machine.can_move():
			velocity.x = direction * current_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_speed)

	if state_machine.is_dead():
		velocity.x = move_toward(velocity.x, 0, 1)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if state_machine.current_state.input_allowed:
		var direction: float = get_horizontal_direction()
		update_animation(direction)
		update_facing_direction(direction)

		if event.is_action_pressed("interact"):
			if on_interactable and on_interactable.has_node("InteractionComponent"):
				var interaction_comp: InteractionComponent = on_interactable.get_node("InteractionComponent")
				interaction_comp.interact()
			if on_collectible and on_collectible.has_node("CollectionComponent"):
				var collection_comp: CollectionComponent = on_collectible.get_node("CollectionComponent")
				collection_comp.collect()

		if (Input.is_action_pressed("up", true)):
			if is_ladder_above:
				state_machine._on_change_state("ladder")
			elif climbing:
				state_machine._on_change_state("ground")
		elif (Input.is_action_pressed("down", true)):
			if is_ladder_below():
				state_machine._on_change_state("ladder")
			elif climbing:
				state_machine._on_change_state("ground")
		
		if (Input.is_action_just_pressed("drink_rum") && rum_bottles > 0):
			SignalBus.emit_signal("rum_consumed")
			damageable.health = damageable.health + 20
			rum_bottles = rum_bottles - 1

func update_animation(direction: float = 0) -> void:
	animation_tree.set("parameters/move/blend_position", direction)

func update_facing_direction(direction: float) -> void:
	if direction < 0:
		sprite.flip_h = true
		if sign(sword_collision.position.x) == 1:
			sword_collision.position.x *= -1
	elif direction > 0:
		sprite.flip_h = false
		if sign(sword_collision.position.x) == -1:
			sword_collision.position.x *= -1

func _on_interact_area_entered(area: Area2D) -> void:
	if area is Ladder:
		on_ladder = area
	elif area.has_node("InteractionComponent"):
		on_interactable = area
	elif area.has_node("CollectionComponent"):
		on_collectible = area
	
	if area.has_node("ButtonPromptComponent"):
		var button_prompt_comp: ButtonPromptComponent = area.get_node("ButtonPromptComponent")
		button_prompt_comp.show_prompt()

func _on_interact_area_exited(area: Area2D) -> void:
	if area is Ladder:
		climbing = false
		on_ladder = null
	elif area.has_node("InteractionComponent"):
		on_interactable = null
	elif area.has_node("CollectionComponent"):
		on_collectible = null
	
	if area.has_node("ButtonPromptComponent"):
		var button_prompt_comp: ButtonPromptComponent = area.get_node("ButtonPromptComponent")
		button_prompt_comp.hide_prompt()

func set_health(value: int) -> void:
	damageable.health = value

func get_health() -> int:
	return damageable.health

func is_ladder_below() -> bool:
	return floor_check.is_colliding()

func get_vertical_direction() -> float:
	return Input.get_axis("up", "down")

func get_horizontal_direction() -> float:
	return Input.get_axis("left", "right")

func _on_ladder_above_area_exited(_area: Area2D) -> void:
	is_ladder_above = false

func _on_ladder_above_area_entered(_area: Area2D) -> void:
	is_ladder_above = true

func add_rum_bottle() -> void:
	rum_bottles = rum_bottles + 1
	max_rum_bottles = max_rum_bottles + 1
