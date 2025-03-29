extends Node2D

var player = preload("uid://dl2snoojjsghs")

func _ready() -> void:
	MapManager.load_map("test")
	spawn_player()
	
	
func spawn_player():
	var node: Player = player.instantiate()
	node.respawn(MapData.instance.spawn_point)
	add_child(node)
