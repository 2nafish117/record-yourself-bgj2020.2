tool
extends EditorScript

export(String) var path = "res://Assets/Audio/Music/"

func add_audio_file(name: String) -> void:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	
	for file in files:
		var file_path = path + file
		

func _run() -> void:
	var node = Sprite.new()
	get_scene().add_child(node)
	node.set_owner(get_scene())
