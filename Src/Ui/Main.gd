extends Control

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Src/Ui/LevelSelection.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
