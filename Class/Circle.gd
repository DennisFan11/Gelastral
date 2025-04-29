@tool
class_name Circle extends Node2D
@export var radius: float = 10

const HINT_COLOR: Color = Color(Color.AQUAMARINE, 1.0)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, HINT_COLOR)
