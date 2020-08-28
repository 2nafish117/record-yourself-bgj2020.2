extends Button

export(Color) var normal_color
export(Color) var focused_color
export(Color) var pressed_color

export(PackedScene) var scene

func _ready() -> void:
	$TextureRect.self_modulate = normal_color

func _on_LevelButton_focus_entered() -> void:
	$TextureRect.self_modulate = focused_color
	$TextureRect.rect_scale.x = 1.2


func _on_LevelButton_focus_exited() -> void:
	$TextureRect.self_modulate = normal_color
	$TextureRect.rect_scale.x = 1.0

func _on_LevelButton_mouse_entered() -> void:
	$TextureRect.self_modulate = focused_color
	$TextureRect.rect_scale.x = 1.2


func _on_LevelButton_mouse_exited() -> void:
	$TextureRect.self_modulate = normal_color
	$TextureRect.rect_scale.x = 1.0


func _on_LevelButton_button_down() -> void:
	$TextureRect.self_modulate = pressed_color


func _on_LevelButton_button_up() -> void:
	$TextureRect.self_modulate = focused_color

