extends Node

export(bool) var randomize_order := false

var tracks := []
var current_track_index := 0

func _ready() -> void:
	for c in get_children():
		tracks.append(c)
	
	if randomize_order:
		randomize()
		tracks.shuffle()
		
	tracks[0].play()
	tracks[0].connect("finished", self, "play_next_track")

func play_next_track():
	print("play_next_track", current_track_index)
	print(tracks)
	tracks[current_track_index].stop()
	current_track_index += 1
	tracks[current_track_index].play()
	tracks[current_track_index].connect("finished", self, "play_next_track")
