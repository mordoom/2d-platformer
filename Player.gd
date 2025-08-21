extends CharacterBody2D

const SPEED = 300.0
var current_speed = SPEED

const JUMP_VELOCITY = -400.0
var dodge_rolling = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * current_speed
	elif !dodge_rolling:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("ui_roll") && velocity.x != 0 && is_on_floor()):
		#dodge_roll()
		pass

func dodge_roll():
	var tween = get_tree().create_tween()
	var color_rect = $ColorRect
	var original_y = color_rect.position.y

	color_rect.pivot_offset = color_rect.size / 2
	dodge_rolling = true
	current_speed = SPEED * 2
	
	tween.parallel().tween_property(color_rect, "rotation", color_rect.rotation - deg_to_rad(360), 0.5)
	tween.parallel().tween_property(color_rect, "scale:y", 0.5, 0.25)
	tween.parallel().tween_property(color_rect, "position:y", original_y + 12, 0.25)
	tween.tween_property(color_rect, "scale:y", 1.0, 0.25)
	tween.parallel().tween_property(color_rect, "position:y", original_y, 0.25)
	
	tween.tween_callback(func(): 
		current_speed = SPEED
		dodge_rolling = false
	)
