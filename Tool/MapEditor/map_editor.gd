extends Node2D



var brush:BlockDrawingTool:
	set(new):
		if is_instance_valid(brush): brush.queue_free()
		brush = new

## 建立實例
func _on_brush_button_button_down() -> void:
	brush = BlockDrawingTool.new()
	add_child(brush)


func _on_circle_button_button_down() -> void:
	brush.Shape = BlockDrawingTool.SHAPE.CIRCLE


func _on_square_button_button_down() -> void:
	brush.Shape = BlockDrawingTool.SHAPE.SQUARE


func _on_point_button_button_down() -> void:
	brush.Type = BlockDrawingTool.TYPE.POINT


func _on_line_button_button_down() -> void:
	brush.Type = BlockDrawingTool.TYPE.LINE


func _on_id_enter_button_button_down() -> void:
	brush.ID = int(%IDEdit.text)


func _on_radius_enter_button_button_down() -> void:
	brush.Radius = float(%IDEdit.text)
