extends Area2D

onready var sprite := $ButtonBase/Button

export(float) var activation_mass := 1.0
export(Color) var not_pressed_color
export(Color) var pressed_color

onready var linked_objects = []

var activated := 0 setget set_activated

func _ready() -> void:
	sprite.self_modulate = not_pressed_color
	for c in get_children():
		if c.has_method("toggle_active"):
			linked_objects.append(c)

func set_activated(val: int) -> void:
	activated = val
	sprite.self_modulate = pressed_color if activated > 0 else not_pressed_color
	for obj in linked_objects:
		obj.toggle_active()

func _on_Button_body_entered(body: Node) -> void:
	if body is RigidBody2D and body.mass >= activation_mass:
		set_activated(activated + 1)

# warning-ignore:unused_argument
func _on_Button_body_exited(body: Node) -> void:
	set_activated(activated - 1)
