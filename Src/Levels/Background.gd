extends ParallaxLayer

onready var old_color = $Sprite.self_modulate
onready var current_color = old_color
onready var new_color = get_new_color()

func get_new_color() -> Color:
	var r := rand_range(0.4, 0.6)
	var g := rand_range(0.4, 0.6)
	var b := rand_range(0.4, 0.6)
	# print("new_color", Color(r, g, b, 1.0))
	return Color(r, g, b, 1.0)

func _on_Timer_timeout() -> void:
	old_color = new_color
	new_color = get_new_color()

func _process(delta: float) -> void:
	print(old_color, new_color)
	current_color = old_color.linear_interpolate(new_color, 1.0 - $Timer.time_left / $Timer.wait_time)
	$Sprite.self_modulate = current_color
