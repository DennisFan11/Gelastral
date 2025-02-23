class_name DestoryableBlockBaseScene extends Node2D

var ID:int
var Position:Vector2:
	set(new):
		Position = new
		position = new
var Polygon:PackedVector2Array: # global polygon
	set(new):
		Polygon = new
		var local_polygon = _to_local_polygon(new)
		%Polygon2D.polygon = local_polygon
		%CollisionPolygon2D.set_deferred("polygon", local_polygon)
		%Line2D.points = local_polygon

## 將全域座標的 polygon 轉換為本地 
func _to_local_polygon( global_polygon:PackedVector2Array )-> PackedVector2Array:
	var local_polygon:PackedVector2Array = []
	for pos:Vector2 in global_polygon:
		local_polygon.append(to_local(pos))
	return local_polygon

func _ready() -> void:
	Position = Position
	Polygon = Polygon
