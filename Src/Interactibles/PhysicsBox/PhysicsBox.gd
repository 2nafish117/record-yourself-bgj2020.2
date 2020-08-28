extends RigidBody2D

signal item_created
signal item_destroyed

export(float) var dissolve_duration := 1.0

func destroy() -> void:
	emit_signal("item_destroyed")
	$CollisionShape2D.call_deferred("set_disabled", true)
	call_deferred("set_mode", RigidBody2D.MODE_KINEMATIC)
	$Tween.interpolate_property($PhysicsBox.get_material(), "shader_param/dissolve_amount", 0.0, 1.0, dissolve_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _ready() -> void:
	emit_signal("item_created")
	pass

func _on_Tween_tween_all_completed() -> void:
	queue_free()
