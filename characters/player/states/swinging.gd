extends CharacterState

var swingable: SwingRope

func _ready():
	set_guard(climbing_allowed_check)

func climbing_allowed_check() -> bool:
	return hsm.blackboard.get_var(GameConstants.BlackboardVars.swingable_above_var) != null

func _enter() -> void:
	super._enter()
	swingable = hsm.blackboard.get_var(GameConstants.BlackboardVars.swingable_above_var)
	blackboard.set_var(GameConstants.BlackboardVars.climbing_var, true)

func _update(_delta: float) -> void:
	var action_pressed: StringName = blackboard.get_var(GameConstants.BlackboardVars.action_pressed_var)

	owner.global_position.x = swingable.marker.global_position.x
	owner.global_position.y = swingable.marker.global_position.y
	owner.global_rotation = swingable.marker.global_rotation

	if action_pressed == &"jump" || InputBuffer.is_action_press_buffered(&"jump"):
		hsm.dispatch(&"jump_started")
	

func _exit() -> void:
	blackboard.set_var(GameConstants.BlackboardVars.climbing_var, false)
	swingable = null
	owner.global_rotation = 0
