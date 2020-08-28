extends Camera2D

onready var player := get_parent() as RigidBody2D
export var look_ahead_factor := Vector2(0.3, 0.1)
export(float) var snappiness := 2.0

func _process(delta: float) -> void:
	position = position.linear_interpolate(player.linear_velocity * look_ahead_factor, delta * snappiness)
