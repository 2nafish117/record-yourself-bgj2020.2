extends Node2D

onready var gun := $Gun

export(float) var turn_speed := 1.5
export(float) var react_time := 1.0
export(float) var evaluation_time := 0.3
export(float) var search_time := 4.0

enum {
	SLEEPING,
	SEARCHING,
	SHOOTING
}

var state := SLEEPING
var targets := []
var current_target

onready var turret_range := $Area2D/CollisionShape2D.shape.radius as float
onready var raycast := $Raycast

func _physics_process(delta: float) -> void:
	match state:
		SLEEPING:
			state_sleeping(delta)
			
		SEARCHING:
			state_searching(delta)
			
		SHOOTING:
			state_shooting(delta)

# warning-ignore:unused_argument
func state_sleeping(delta: float) -> void:
	if !raycast.enabled:
		return
	for target in targets:
		raycast.cast_to = target.global_position
		var collision = raycast.get_collider()
		if collision == target:
			yield(get_tree().create_timer(react_time), "timeout")
			state = SEARCHING
			current_target = target

func state_searching(delta: float) -> void:
	var target_angle = Vector2.RIGHT.rotated(gun.rotation).angle_to(current_target.global_position - global_position)
	var add_rotation = sign(target_angle) * turn_speed * delta
	gun.rotation += add_rotation
	if add_rotation <= 0.01:
		state = SHOOTING
	pass

# warning-ignore:unused_argument
func state_shooting(delta: float) -> void:
	pass

func _on_Area2D_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		targets.append(body)
		raycast.enabled = true

func _on_Area2D_body_exited(body: Node) -> void:
	if body is RigidBody2D:
		targets.erase(body)
		if len(targets) <= 0:
			raycast.enabled = false
