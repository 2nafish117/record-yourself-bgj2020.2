extends Area2D

export(bool) var active := true

var player = null

func toggle_active() -> void:
	active = not active
	visible = active
	if player != null:
		if active:
			player.disable_record_ability()
		else:
			player.enable_record_ability()

func _on_AntiRecorder_body_entered(body: Node) -> void:
	if active and body is RigidBody2D and body.is_in_group("Player"):
		player = body
		body.recorder.disable_record_ability()

func _on_AntiRecorder_body_exited(body: Node) -> void:
	if active and body is RigidBody2D and body.is_in_group("Player"):
		player = null
		body.recorder.enable_record_ability()
