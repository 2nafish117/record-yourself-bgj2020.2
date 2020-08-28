extends Control

onready var buttons = $CenterContainer/GridContainer.get_children()

func _ready() -> void:
	for button in buttons:
		button.connect("pressed", self, "load_scene", [button.scene])
		print("connected")
		
func load_scene(scene: PackedScene) -> void:
	print("pressed")
	get_tree().change_scene_to(scene)
	pass

func _on_Back_pressed() -> void:
	get_tree().change_scene("res://Src/Ui/Main.tscn")
