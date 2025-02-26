extends Node2D

const CameraSpeed:float = 5 # lerp time
const CameraZoomSpeed:float = 1.2 
const CameraZoomTime:float = 0.08 #0.05

var brush:BlockDrawingTool:
	set(new):
		if is_instance_valid(brush): brush.queue_free()
		brush = new

var CameraTargetPosition = Vector2.ZERO
func _process(delta: float) -> void:
	CameraTargetPosition += Input.get_vector("left", "right", "up", "down") * 165 * delta
	$Camera2D.position = $Camera2D.position.lerp(CameraTargetPosition, CameraSpeed*delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("load"):
		MapManager.load_map("test")
	elif event.is_action_pressed("save"):
		MapManager.save_map("test")
	elif event.is_action_pressed("scroll_down"):
		#%Camera2D.zoom *= 0.9
		var tween := get_tree().create_tween()
		tween.tween_property($Camera2D,"zoom",$Camera2D.zoom / CameraZoomSpeed,CameraZoomTime)
	elif event.is_action_pressed("scroll_up"):
		#%Camera2D.zoom *= 1.1
		var tween := get_tree().create_tween()
		tween.tween_property($Camera2D,"zoom",$Camera2D.zoom * CameraZoomSpeed,CameraZoomTime)

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
	brush.Radius = float(%RadiusEdit.text)
