class_name HintPolygon
extends Node2D



var polygon:PackedVector2Array:
	set(new):
		polygon = new
		%Polygon2D.polygon = new
		%Line2D.points = new

var color:Color:
	set(new):
		color = new
		%Polygon2D.modulate = new
		%Line2D.modulate = new
