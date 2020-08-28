extends KinematicBody2D

# signal locked
# signal unlocked

export(bool) var active := true setget set_active

func toggle_active() -> void:
	set_active(!active)

func set_active(val: bool) -> void:
	$Door.visible = val
	active = val
	$CollisionShape2D.call_deferred("set_disabled", !val)
	# emit_signal("locked" if val else "unlocked")
