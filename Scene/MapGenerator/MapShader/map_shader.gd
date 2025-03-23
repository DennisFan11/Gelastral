extends Node2D

const TEXTURE_SIZE := Vector2(128, 128)
func get_scan_array()-> Array[Node]:
	return get_children()
func set_size(size:Vector2):
	scale = size/TEXTURE_SIZE
