extends CanvasLayer

func _on_LevelButton_pressed() -> void:
	get_tree().change_scene("res://Src/Ui/LevelSelection.tscn")
