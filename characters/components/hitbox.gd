class_name Hitbox
extends Area2D

@export var contact_sound: AudioStream
@export var monitoring_default := false
@export var damage := 10
@export var knockback_velocity := 100.0
@export var can_deflect := false
@export var can_be_deflected := true
@export var stun := false
@export var teleport_to_safety := false

var teleport_time := 0.5
var last_hurt_player: Node2D

signal hit

func _ready():
	monitoring = monitoring_default
	connect("area_entered", _on_area_entered)

func flip(current_direction: float) -> void:
	if current_direction < 0:
		scale.x = -1
	elif current_direction > 0:
		scale.x = 1

func die() -> void:
	set_deferred("monitoring", false)

func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		var hurtbox: Hurtbox = area
		var direction := (hurtbox.global_position - global_position).normalized()
		hurtbox.on_hurtbox_hit(self, direction)
		emit_signal("hit")
		if contact_sound:
			SoundManager.play_sound_with_pitch(contact_sound, Rng.generate_random_pitch())
		if teleport_to_safety:
			last_hurt_player = area.owner
			var timer = Timer.new()
			timer.wait_time = teleport_time
			timer.one_shot = true
			timer.timeout.connect(_on_timer_timeout)
			add_child(timer)
			timer.start()

func _on_timer_timeout() -> void:
	var nearest_safe_point = get_tree().get_nodes_in_group("SafePoint")[0]
	last_hurt_player.global_position = nearest_safe_point.global_position
