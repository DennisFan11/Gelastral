extends Node2D

var player = preload("uid://dl2snoojjsghs")

func _ready() -> void:
	MapManager.load_map("test")
	
	
func spawn_player():
	var node = player.instantiate()
	node.position = MapData.instance.spawn_point
	add_child(node)
