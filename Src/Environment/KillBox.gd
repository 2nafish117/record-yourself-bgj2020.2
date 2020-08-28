extends Area2D

func _on_Spikes_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		if body.has_method("destroy"):
			body.destroy()
		else:
			body.queue_free()
			pass
