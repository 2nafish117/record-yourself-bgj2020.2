extends StaticBody2D

export(int) var num_items := 1
export(PackedScene) var Item

func _ready() -> void:
	for c in $Items.get_children():
		c.connect("item_destroyed", self, "spawn_box")
		
	for _i in range(num_items - $Items.get_child_count()):
		spawn_box()

func spawn_box():
	var item = Item.instance()
	item.global_position = $SpawnPoint.position
	item.connect("item_destroyed", self, "spawn_box")
	$Items.call_deferred("add_child", item)
