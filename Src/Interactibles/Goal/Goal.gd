extends Node2D

export(PackedScene) var next_scene

func _on_Area2D_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.collision_layer == (1 << 1):
		get_tree().change_scene_to(next_scene)
