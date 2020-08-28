extends Area2D

export var active := true
export var lift_speed := 70.0

var bodies := []

onready var lights := $GravBase/GravBaseLight

func toggle_active() -> void:
	set_active(!active)

func _ready() -> void:
	set_active(active)

func set_active(val: bool) -> void:
	active = val
	$GravLift.visible = val
	$CollisionShape2D.call_deferred("set_disabled", !active)

func _physics_process(delta: float) -> void:
	if active:
		$GravLift.region_rect.position.y += lift_speed * delta
		
		for body in bodies:
			(body as RigidBody2D).apply_central_impulse(body.weight * 0.2 * Vector2.UP.rotated(global_rotation))
		pass

func _on_Lift_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		bodies.append(body)
		(body as RigidBody2D).gravity_scale = 0.0
		(body as RigidBody2D).linear_damp = 10.0
		
func _on_Lift_body_exited(body: Node) -> void:
	if body is RigidBody2D:
		bodies.erase(body)
		(body as RigidBody2D).gravity_scale = 1.0
		(body as RigidBody2D).linear_damp = -1.0
